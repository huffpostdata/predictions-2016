function formatHumanNumber(n) {
  if (n < 1000) {
    return String(n);
  } else if (n < 1000000) {
    return (n / 1000).toFixed(1) + ' thousand';
  } else {
    return (n / 1000000).toFixed(1) + ' million';
  }
}

function handle_hover_on_vote_counts() {
  var bars_el = document.querySelector('#president-vote-counts .bars');
  if (!bars_el) return;
  var bars = bars_el.childNodes;
  var tooltip = document.querySelector('#president-vote-counts .tooltip');
  var tooltipParts = {
    nClinton: tooltip.querySelector('.clinton strong'),
    nTrump: tooltip.querySelector('.trump strong'),
    n: tooltip.querySelector('p strong')
  };

  function findBarAtX(x) {
    var min = 0;
    var max = bars.length;

    while (min < max) {
      var mid = (min + max) >> 1; // min <= mid < max
      var bar = bars[mid];
      var bar_x1 = bar.offsetLeft;
      var bar_x2 = bar_x1 + bar.offsetWidth;

      if (bar_x1 <= x && bar_x2 >= x) {
        return bar;
      } else if (bar_x2 < x) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }

    return bars[bars.length - 1];
  }

  function findTallestBar() {
    var max = -1;
    var ret = null;

    for (var i = 0; i < bars.length; i++) {
      var bar = bars[i];
      var n = +bar.getAttribute('data-n');
      if (n > max) {
        max = n;
        ret = bar;
      }
    }

    return ret;
  }

  var tallestBar = findTallestBar();
  var focalBar = bars[0];
  focalBar.classList.add('focus');

  function focusBar(bar) {
    if (bar === focalBar) return;

    focalBar.classList.remove('focus');
    focalBar = bar;
    focalBar.classList.add('focus');

    var n = +bar.getAttribute('data-n');
    var count = +bar.getAttribute('data-count');

    tooltip.className = 'tooltip';
    tooltip.style.left = bar.offsetLeft + 'px';
    if (tooltip.offsetLeft < 0) {
      tooltip.style.left = '0';
      tooltip.classList.add('flush-left');
    }
    if (tooltip.offsetLeft + tooltip.offsetWidth > bars_el.clientWidth) {
      tooltip.style.left = '';
      tooltip.classList.add('flush-right');
    }

    tooltipParts.nClinton.textContent = String(count);
    tooltipParts.nTrump.textContent = String(538 - count);
    tooltipParts.n.textContent = formatHumanNumber(n);
  }

  function focus(ev) {
    var bar = findBarAtX(ev.clientX - bars_el.parentNode.offsetLeft);
    focusBar(bar);
  }

  function leave() {
    focusBar(tallestBar);
  }

  tooltip.classList.remove('loading');
  focusBar(tallestBar);
  bars_el.addEventListener('mousemove', focus);
  bars_el.addEventListener('mouseleave', leave);
}

/**
 * Create sparklines out of win probabilities.
 */
function make_win_probabilities_histograms() {
  var mainContainer = document.getElementById('president-races');
  if (!mainContainer) return;

  var histograms = []; // { canvas, container, min, max, buckets, mean, stddev }
  function collectHistograms(html_class, min, max) {
    var canvases = mainContainer.querySelectorAll('ul.races.' + html_class + ' canvas');
    for (var i = 0; i < canvases.length; i++) {
      var canvas = canvases[i];
      var container = canvas.parentNode;
      var mean = +container.getAttribute('data-xibar');
      var stddev = +container.getAttribute('data-stddev');
      histograms.push({
        canvas: canvas,
        container: container,
        min: min,
        max: max,
        mean: mean,
        stddev: stddev
      });
    }
  }
  collectHistograms('likely-clinton', -0, 30);
  collectHistograms('battlegrounds', 30, -30);
  collectHistograms('likely-trump', 0, -30);

  function normalCdf(x) {
    // http://papers.ssrn.com/sol3/papers.cfm?abstract_id=2579686
    var sign = x > 0 ? 1 : -1;
    return 0.5 * (1 + sign * Math.sqrt((1 - Math.exp(-2 / Math.PI * x * x))));
  }

  function barFraction(bucketMin, bucketMax, mean, stddev) {
    var cd1 = normalCdf((bucketMax - mean) / stddev);
    var cd2 = normalCdf((bucketMin - mean) / stddev);
    return Math.abs(cd2 - cd1);
  }

  function refresh() {
    var aContainer = histograms[0].container; // they're all the same size
    var containerStyle = window.getComputedStyle(aContainer);
    var width = aContainer.clientWidth;
    var height = aContainer.clientHeight - parseFloat(containerStyle.paddingTop) - parseFloat(containerStyle.paddingBottom);

    var nBuckets = Math.floor((width + 2) / 5);
    // We want an odd number of buckets, so the mean is highest
    if (nBuckets % 2 === 0) nBuckets -= 1;
    //var nBuckets = width;
    var bucketWidth = Math.floor(width / nBuckets);
    var maxFraction = 0;
    var strongDem = '#4c7de0';
    var strongGop = '#e52426';
    var mutedDem = '#afbaf9';
    var mutedGop = '#f19192';
    var tossUp = '#999';

    histograms.forEach(function(histogram) {
      var bucketSize = (histogram.max - histogram.min) / nBuckets;
      var buckets = histogram.buckets = [];
      for (var i = 0; i < nBuckets; i++) {
        var min = histogram.min + bucketSize * i;
        var max = histogram.min + bucketSize * (i + 1);
        var isMean = (min <= histogram.mean) === (max >= histogram.mean);
        var fraction = barFraction(min, max, histogram.mean, histogram.stddev);
        var color = (min <= 0 && max >= -0) ? tossUp : (min > 0 ? (isMean ? strongDem : mutedDem) : (isMean ? strongGop : mutedGop));

        buckets.push({
          color: color,
          fraction: fraction
        });

        if (fraction > maxFraction) maxFraction = fraction;
      }
    });

    // x0: left of first rect. Each bucket is 5px wide, with the rect in the
    // middle 3px. The first and last buckets are only 4px wide, so the rect is
    // flush to the edge in those cases. That's why there's no "+ 1" here.
    var x0 = Math.floor((width - (bucketWidth * nBuckets)) / 2);
    //var x0 = 0;

    histograms.forEach(function(histogram) {
      var canvas = histogram.canvas;
      canvas.width = width;
      canvas.height = height;

      var ctx = canvas.getContext('2d');
      ctx.clearRect(0, 0, width, height);

      histogram.buckets.forEach(function(bucket, i) {
        var x = x0 + 5 * i;
        //var x = x0 + i;
        var h = height * bucket.fraction / maxFraction;

        ctx.fillStyle = bucket.color;
        ctx.fillRect(x, height - h, 3, h);
      });
    });
  }

  var deferredRefresh = null; // Timeout
  function deferRefresh() {
    if (deferredRefresh !== null) return;
    deferredRefresh = window.setTimeout(function() {
      refresh();
      deferredRefresh = null;
    }, 250);
  }

  refresh();
  window.addEventListener('resize', deferRefresh);
}

document.addEventListener('DOMContentLoaded', function() {
  handle_hover_on_vote_counts();
  make_win_probabilities_histograms();
});
