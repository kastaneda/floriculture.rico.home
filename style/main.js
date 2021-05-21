window.addEventListener("load", function() {
  // Check for WebP support
  var img = new Image();
  img.onload = function () {
    if ((img.width > 0) && (img.height > 0)) {
      // WebP supported
      document.querySelectorAll("a[data-href-webp]").forEach(function(el) {
        el.href = el.dataset.hrefWebp;
      });
    }
  };

  // WebP check based on https://developers.google.com/speed/webp/faq
  img.src = "data:image/webp;base64,UklGRiIAAABXRUJQVlA4IBYAAAAwAQCdASoBAAEADsD+JaQAA3AAAAAA";
});
