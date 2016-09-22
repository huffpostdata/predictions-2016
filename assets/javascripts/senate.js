function tie_expanded_senate_races_to_hash() {
  var container = document.getElementById('senate-races') || document.getElementById('president-races');
  if (!container) return;

  var scroll_anchors = container.querySelectorAll('.scroll-anchor');
  var load_svgs_timeout = null;

  function is_desktop() {
    return window.getComputedStyle(scroll_anchors[0]).display !== 'none';
  }

  function scroll_to_state(state_code) {
    var href = '#expand-states:' + state_code;
    var scroll_anchor = container.querySelector('a[href="' + href + '"]');
    if (scroll_anchor === null) return;
    scroll_anchor.scrollIntoView(true);
  }

  function on_change_update_hash(ev) {
    if (is_desktop()) {
      ev.preventDefault(); // no, don't check it
      var state_code = ev.target.getAttribute('data-state-code');
      scroll_to_state(state_code);
      on_scroll_or_resize_update_hash();
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
    load_svgs_timeout = window.setTimeout(load_missing_senate_race_svgs, 250);
  }

  function on_scroll_or_resize_update_hash() {
    if (!is_desktop()) return;

    // binary-search for first visible anchor
    var min = 0, max = scroll_anchors.length;
    while (min < max) {
      var mid = (min + max) >> 1; // min <= mid < max
      if (scroll_anchors[mid].getBoundingClientRect().top < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }

    // Uncheck everything
    var inputs = container.querySelectorAll('input.expand:checked');
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].checked = false;
    }

    var scroll_anchor = scroll_anchors[min];
    if (scroll_anchor) {
      var input = scroll_anchor.parentNode.querySelector('input.expand');
      input.checked = true;
      window.location.hash = '#expand-states:' + input.getAttribute('data-state-code');

      defer_load_missing_senate_race_svgs();
    }
  }

  read_hash();
  load_missing_senate_race_svgs();
  container.addEventListener('change', function(ev) {
    on_change_update_hash(ev);
    load_missing_senate_race_svgs();
  });
  window.addEventListener('scroll', on_scroll_or_resize_update_hash);
  window.addEventListener('resize', on_scroll_or_resize_update_hash);
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
