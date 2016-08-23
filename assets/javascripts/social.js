(function init_social() {
  function init_facebook() {
    // Stub FB.ui(): if user clicks it before JS loads, this wrapper will keep
    // trying until FB.ui has loaded.
    window.FB_stub = {
      ui: function(x, y) {
        window.setTimeout(function() { (window.FB || window.FB_stub).ui(x, y); }, 500);
      }
    };

    window.fbAsyncInit = function() {
      var meta = document.querySelector('meta[property="fb:app_id"]');
      var facebook_app_id = meta && meta.getAttribute('content') || '';

      FB.init({
        appId: facebook_app_id,
        version: 'v2.5'
      })
    };

    var fb_root = document.createElement('div');
    fb_root.setAttribute('id', 'fb-root');
    document.body.appendChild(fb_root);

    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
  }

  function init_twitter() {
    // https://dev.twitter.com/web/javascript/loading
    window.twttr = (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0],
        t = window.twttr || {};
      if (d.getElementById(id)) return t;
      js = d.createElement(s);
      js.id = id;
      js.src = "//platform.twitter.com/widgets.js";
      fjs.parentNode.insertBefore(js, fjs);
     
      t._e = [];
      t.ready = function(f) {
        t._e.push(f);
      };
      return t;
    }(document, "script", "twitter-wjs"));
  }

  init_facebook();
  init_twitter();

  document.addEventListener('click', function(ev) {
    var className = ev.target.className;

    if (/\bfacebook-share\b/.test(className)) {
      ev.preventDefault();

      var url = ev.target.getAttribute('data-url') || window.location.href;

      (window.FB || window.FB_stub).ui({
        method: 'share',
        href: url
      }, function(response){});
    } else if (/\btwitter-share\b/.test(className)) {
      ev.preventDefault();

      var meta = document.querySelector('meta[property="suggested-tweet"]');
      var text = ev.target.getAttribute('data-text') || (meta && meta.getAttribute('content')) || '';
      var url = ev.target.getAttribute('data-url') || window.location.href;
      var encoded_text = encodeURIComponent(text);
      var encoded_url = encodeURIComponent(url);
      var href = 'https://twitter.com/intent/tweet?text=' + encoded_text + '&url=' + encoded_url;

      var a = document.createElement('a');
      a.setAttribute('href', href);
      twttr.ready(function() { a.click(); });
    }
  });
}());
