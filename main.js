window.addEventListener('load', function() {
  var initPswp = function() {
    var slides = [];
    var slideCount = 0;
    var pswpElement = document.querySelector('.pswp');
    var pswpOptions = {
      showHideOpacity: true,
      getThumbBoundsFn: function (idx) {
        var pageYScroll = window.pageYOffset || document.documentElement.scrollTop;
        var rect = slides[idx].el.getBoundingClientRect();
        var i = slides[idx].el.querySelector('img');
        return {
          x: rect.left - (i.naturalWidth - i.width) / 2,
          y: rect.top + pageYScroll - (i.naturalHeight - i.height) / 2,
          w: i.naturalWidth
        };
      }
    };
    
    var onSlideClick = function (e) {
      e = e || window.event;
      e.preventDefault ? e.preventDefault() : e.returnValue = false;
      var el = e.target || e.srcElement;
      while (el.parentNode && el.tagName.toUpperCase() != 'A') el = el.parentNode;
      var opt = pswpOptions;
      opt.index = parseInt(el.dataset.index);
      var pswp = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, slides, opt);
      pswp.init();
    };
    
    document.querySelectorAll('a.thumbnail').forEach(function (el) {
      slides.push({
        el: el,
        src: el.href,
        msrc: el.dataset.msrc || el.querySelector('img').src,
        w: el.dataset.pswpWidth,
        h: el.dataset.pswpHeight
      });
      el.dataset.index = slideCount++;
      el.addEventListener('click', onSlideClick);
    });
  };

  var tryWebp = new Image();
  tryWebp.onload = function () {
    if ((tryWebp.width > 0) && (tryWebp.height > 0)) {
      document.querySelectorAll('a.thumbnail').forEach(function (el) {
        el.href = el.href.replace(/jpg$/, 'webp');
        el.dataset.msrc = el.querySelector('source').srcset;
      });
    }
    initPswp();
  };

  tryWebp.src = 'data:image/webp;base64,UklGRiIAAABXRUJQVlA4IBYAAAAwAQCdASoBAAEADsD+JaQAA3AAAAAA';
});
