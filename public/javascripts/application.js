// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var WatchMeMakeThis = {
  fancyboxify:function() {
    $('#build_images a.thumb').fancybox({'cyclic':true,'transitionIn':'elastic','transitionOut'	:'elastic'});
  }
};

$('header nav select').change(function() {
  location.href = '/' + this.value;
});

$('.image .delete').live('ajax:success', function() {
  $(this).parents('li.image').fadeOut();
});

$.support.dragDropUpload = (function(){ 
  var support = false
  var match, major, minor
  if (navigator && navigator.userAgent) {
    var ua = navigator.userAgent;
  
    // look for firefox
    if ($.browser.mozilla) {
      match = ua.match(/Firefox\/(\d*)\.(\d*)\./);
      if (match) {
        major = parseInt(match[1]);
        minor = parseInt(match[2]);
        if ((major > 3) || (major == 3 && minor >= 6)) {
          support = true;
        }
      }
    } else if ($.browser.webkit) {
      // look for chrome
      match = ua.match(/Chrome\/(\d*)\./);
      if (match) {
        support = true;
      } else {
        // look for safari
        match = ua.match(/Version\/(\d*)\./);
        if (match) {
          major = parseInt(match[1]);
          if (major >= 4) {
            support = true;
          }
        }
      }
    }
  }
  return support; 
})();