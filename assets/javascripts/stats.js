(function() {
  var GOOGLE_ANALYTICS_ID = 'UA-61898491-1';
  var AUTHOR = 'Shane Shifflett';
  var TAGS = 'jail-deaths-database';

  // Google Analytics
  ;(function() {
    //load GA
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', GOOGLE_ANALYTICS_ID, 'auto');
    ga('send', 'pageview');
  }());


  //CMS entry
  //https://us.edit.huffpost.net/cms/entry/5785558de4b0867123dec44d/settings
  //http://www.huffingtonpost.com/entry/presumed-innocent-found-dead_us_5785558de4b0867123dec44d?qrn8idgkmii5jc3di
  var isMobile = function(agent){return /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(agent)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(agent.substr(0,4))}(navigator.userAgent||navigator.vendor||window.opera);

  bN_cfg = {
    h: location.hostname,
    p: {
      "dL_ch": (isMobile ? "us.hpmghighln" : "us.hpmghighln_mb"),
      "dL_dpt": "data",
      "cobrand": "HuffPost",
      "dL_blogID": "2",
      "dL_cmsID": "hpo:5745c2d3e4b03ede44136eec",
      "dL_author": AUTHOR,
      "dL_tags": TAGS,
      "dL_crtdt": "2016-07-13 13:00:00",
    }
  }

  function runOmni() {
    s_265.pfxID = 'hpo';
    s_265.channel = (isMobile ? "us.hpmghighln" : "us.hpmghighln_mb");
    s_265.linkInternalFilters = 'javascript:,huffingtonpost.com';
    s_265.prop16 = 'page';
    s_265.prop1 = 'data';
    s_265.prop62 = 'video_novideo'; // As per Andrea Wright, 2016-03-17
    s_265.prop65 = 'ap'; // The main source of election-2016 data is Associated Press
    s_265.pageName = "" + document.title;
    s_265.prop12 = "" + document.URL.split('?')[0];
    s_265.t();
  }

  s_265_account = "aolhuffposthighline,aolsvc";

  (function(d){
    var head = d.getElementsByTagName('head')[0];

    var s;

    s = d.createElement('script');
    s.src = "http://o.aolcdn.com/os_merge/?file=/aol/beacon.min.js&file=/aol/omniture.min.js";
    head.appendChild(s);

    s = d.createElement('script');
    s.src = (document.location.protocol == 'https' ? 'https://sb' : 'http://b') + '.scorecardresearch.com/beacon.js';
    head.appendChild(s);
  })(document);

  var parsely_root = document.createElement('div');
  parsely_root.setAttribute('id', 'parsely-root');
  parsely_root.setAttribute('style', 'display:none;');
  var parsely_cfg = document.createElement('span');
  parsely_cfg.setAttribute('id', 'parsely-cfg');
  parsely_cfg.setAttribute('data-parsely-site', 'huffingtonpost.com');
  parsely_root.appendChild(parsely_cfg);
  document.body.appendChild(parsely_root);

  (function(s, p, d) {
    var h=d.location.protocol, i=p+"-"+s,
        e=d.getElementById(i), r=d.getElementById(p+"-root"),
        u=h==="https:"?"d1z2jf7jlzjs58.cloudfront.net"
        :"static."+p+".com";
    if (e) return;
    e = d.createElement(s); e.id = i; e.async = true;
    e.src = h+"//"+u+"/p.js"; r.appendChild(e);
  })("script", "parsely", document);


  // Workaround so Omniture tracking code doesn't crash on pages w/ SVG
  if (typeof SVGAnimatedString !== 'undefined') {
    SVGAnimatedString.prototype.indexOf = function indexOf() { };
  }

  function runNielson(){
    var div = document.createElement('div');
    div.setAttribute('id', 'nielson-tracker');
    div.setAttribute('style', 'display:none');
    document.body.appendChild(div);

    var d = new Image(1, 1);
    d.onerror = d.onload = function() {
        d.onerror = d.onload = null;
    };
    var ts_value = "ts=compact";

    d.src = [
        "//secure-us.imrworldwide.com/cgi-bin/m?ci=us-703240h&cg=0&cc=1&si=",
        escape(window.location.href),
        "&rp=",
        escape(document.referrer),
        "&",
        ts_value,
        "&rnd=",
        (new Date()).getTime()
    ].join('');

    document.getElementById('nielson-tracker').appendChild(d);
  }

  runNielson();

  function runComscore() {
    var kw = isMobile ? 'mobile_politics' : 'politics';

    COMSCORE.beacon({
      c1: 2,
      c2: 6723616,
      c3: "",
      c4: "",
      c5: kw,
      c6: "",
      c15: "",
      options: {
        url_append: "comscorekw=" + kw
      }
    });
  }

  function tryComscore() {
    if (typeof COMSCORE !== 'undefined') {
      runComscore();
    } else {
      window.setTimeout(tryComscore, 500);
    }
  }

  tryComscore();
}());
