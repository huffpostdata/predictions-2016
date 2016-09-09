function tie_expanded_senate_races_to_hash() {
  var container = document.getElementById('senate-races');
  if (!container) return;

  function update_hash() {
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
    if (!hash.startsWith('#expand-states:')) return;

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
  }

  read_hash();
  load_missing_senate_race_svgs();
  container.addEventListener('change', function() {
    update_hash();
    load_missing_senate_race_svgs();
  });
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
