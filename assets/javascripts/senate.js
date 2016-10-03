function tie_expanded_senate_races_to_hash() {
  var container = document.getElementById('senate-races') || document.getElementById('president-races');
  if (!container) return;

  var scroll_anchors = container.querySelectorAll('.scroll-anchor');
  var load_svgs_timeout = null;
  var is_desktop = false;

  function reset_is_desktop() {
    is_desktop = window.getComputedStyle(scroll_anchors[0]).display !== 'none';
  }

  function scroll_to_state(state_code) {
    var href = '#expand-states:' + state_code;
    var scroll_anchor = container.querySelector('a[href="' + href + '"]');
    if (scroll_anchor === null) return;
    scroll_anchor.scrollIntoView(true);
  }

  function on_change_update_hash(ev) {
    if (is_desktop) {
      ev.preventDefault(); // no, don't check it
      var state_code = ev.target.getAttribute('data-state-code');
      scroll_to_state(state_code);
      return;
    }

    var inputs = container.querySelectorAll('input.expand:checked');
    var state_codes = [];
    for (var i = 0; i < inputs.length; i++) {
      var input = inputs[i];
      state_codes.push(input.value);
    }

    if (state_codes.length == 0) {
      //window.location.hash = '#-';
      window.history.replaceState({}, '', window.location.pathname);
    } else {
      window.location.hash = '#expand-states:' + state_codes.join(',');
    }
  }

  function read_hash() {
    var hash = window.location.hash;
    if (!/^#expand-states:/.test(hash)) return;

    var state_codes = hash.slice('#expand-states:'.length).split(',');
    var state_code_set = {};
    state_codes.forEach(function(state_code) { state_code_set[state_code] = null; });

    var inputs = container.querySelectorAll('input.expand');
    for (var i = 0; i < inputs.length; i++) {
      var input = inputs[i];
      input.checked = state_code_set.hasOwnProperty(input.value);
    }
  }

  function load_missing_senate_race_svg(loading_div) {
    var parentNode = loading_div.parentNode;
    var img = new Image();
    img.src = loading_div.getAttribute('data-url');
    img.className = 'loading';
    parentNode.appendChild(img);
    img.onload = function() {
      parentNode.removeChild(loading_div);
      img.className = '';
    };
  }

  function load_missing_senate_race_svgs() {
    var divs = container.querySelectorAll('input.expand:checked + .content-to-expand div.placeholder');
    for (var i = 0; i < divs.length; i++) {
      divs[i].className = 'loading';
      load_missing_senate_race_svg(divs[i]);
    }

    load_svgs_timeout = null;
  }

  function defer_load_missing_senate_race_svgs() {
    // Avoid loading always: we don't want to make people download every SVG
    // just to smooth-scroll to "methodology".
    if (load_svgs_timeout !== null) return;
    load_svgs_timeout = window.setTimeout(load_missing_senate_race_svgs, 100);
  }

  function unfix_everything() {
    var allFixed = container.querySelectorAll('li.fixed');
    for (var i = 0; i < allFixed.length; i++) {
      var fixed = allFixed[i];
      fixed.classList.remove('fixed');
      var detailsInner = fixed.querySelector('.details-inner');
      detailsInner.style.top = -detailsInner.clientHeight * 1/2 + 'px';
    }
  }

  function viewport_midpoint() {
    if (document.documentElement) {
      return document.documentElement.clientHeight / 2;
    } else {
      return window.innerHeight;
    }
  }

  function affix(li) {
    // Ensure the passed <li> is the one we're positioning
    if (li !== affix.li) {
      if (affix.li !== null) {
        if (affix.li.classList.contains('fixed')) {
          affix.li.classList.remove('fixed');
          affix.detailsInner.style.top = -affix.detailsInner.clientHeight * 1/2 + 'px';
        }
      }
      affix.li = li;
      if (affix.li !== null) {
        affix.details = affix.li.querySelector('.details');
        affix.detailsInner = affix.details.childNodes[0];
      }
    }

    // Set the <li> to "fixed" or non-"fixed" position
    if (affix.li !== null) {
      var rect = affix.details.getBoundingClientRect();
      var midViewY = viewport_midpoint();

      if (midViewY >= rect.top && midViewY <= rect.bottom) {
        if (!affix.li.classList.contains('fixed')) {
          affix.li.classList.add('fixed');
          affix.detailsInner.style.top = midViewY - (affix.detailsInner.clientHeight * 1/2) - 1 + 'px'; // 1px for border
        }
      } else {
        // Even when "fixed" isn't set, we need to set style.top
        affix.li.classList.remove('fixed');
        affix.detailsInner.style.top = -affix.detailsInner.clientHeight * 1/2 + 'px';
      }
    }
  }
  affix.li = null;
  affix.details = null;
  affix.detailsInner = null;

  function reset_scroll_anchor_positions() {
    var focusY = viewport_midpoint();
    for (var i = 0; i < scroll_anchors.length; i++) {
      scroll_anchors[i].style.top = -focusY + 'px';
    }
  }

  function on_scroll() {
    on_scroll_or_resize_update_inputs();
  }

  function reset_details_widths() {
    // We reset all widths in one go, so we don't have to reset them on-demand.
    // (It causes a reflow, which is slow.) (Setting the width sets the height.)
    var inners = container.querySelectorAll('.details-inner');
    for (var i = 0; i < inners.length; i++) {
      var detailsInner = inners[i];
      detailsInner.style.width = detailsInner.parentNode.clientWidth + 'px';
    }
  }

  function on_resize() {
    reset_is_desktop();
    affix(null);
    reset_details_widths();
    reset_scroll_anchor_positions();
    on_scroll_or_resize_update_inputs();
  }

  function on_scroll_or_resize_update_inputs() {
    if (!is_desktop) return;

    // binary-search for first visible anchor
    var min = 0, max = scroll_anchors.length;
    while (min < max) {
      var mid = (min + max) >> 1; // min <= mid < max
      var rect = scroll_anchors[mid].getBoundingClientRect();

      if (rect.bottom < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }

    var scroll_anchor = scroll_anchors[min];
    var scroll_anchor_top = scroll_anchor ? scroll_anchor.getBoundingClientRect().top : null;

    // Uncheck everything
    var inputs = container.querySelectorAll('input.expand:checked');
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].checked = false;
    }

    if (scroll_anchor) {
      var input = scroll_anchor.parentNode.querySelector('input.expand');
      input.checked = true;

      var li = input.parentNode;
      affix(li);

      defer_load_missing_senate_race_svgs();
    } else {
      affix(null);
    }
  }

  read_hash();
  load_missing_senate_race_svgs();
  container.addEventListener('change', function(ev) {
    on_change_update_hash(ev);
    load_missing_senate_race_svgs();
  });
  on_resize();
  window.addEventListener('scroll', on_scroll);
  window.addEventListener('resize', on_resize);
}

function shrink_senate_summary_percents() {
  var container = document.getElementById('senate-summary');
  if (!container) return;

  var bars = container.querySelectorAll('ol.chart>li>strong');

  function refresh() {
    for (var i = 0; i < bars.length; i++) {
      var bar = bars[i];
      var w = bar.clientWidth;
      bar.className = w < 45 ? 'tiny' : (w < 70 ? 'small' : '');
    }
  }

  refresh();
  window.addEventListener('resize', refresh);
}

document.addEventListener('DOMContentLoaded', function() {
  tie_expanded_senate_races_to_hash();
  shrink_senate_summary_percents();
});
