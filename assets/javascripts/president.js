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

  tooltip.style.display = 'block';
  focusBar(tallestBar);
  bars_el.addEventListener('mousemove', focus);
  bars_el.addEventListener('mouseleave', leave);
}

document.addEventListener('DOMContentLoaded', function() {
  handle_hover_on_vote_counts();
});
