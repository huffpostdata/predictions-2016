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
      window.location.hash = '#-';
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

  read_hash();
  container.addEventListener('change', update_hash);
}

document.addEventListener('DOMContentLoaded', function() {
  tie_expanded_senate_races_to_hash();
});
