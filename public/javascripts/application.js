// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var WatchMeMakeThis = {
  fancyboxify:function() {
    $('#build_images a[rel=build_group]').fancybox({'cyclic':true,'transitionIn':'elastic','transitionOut':'elastic'});
    $('#build_images a.more').unbind('click').click(function() {
      $(this).parents('li.image').find('a.thumb').click();
      return false;
    });
  },
  
  newBuild:function() {
    // watch for manual keypresses so we don't auto update this
    $('#build_path, #build_hashtag').data('manualEdit',false).bind('keypress', function() {
      $(this).data('manualEdit', true);
    });
    
    $('#build_name').bind('keyup', function() {
      var friendly = $(this).val().toLowerCase().replace(/[^0-9a-zA-Z\.-_'"!]/g,'-').replace(/['"!]/g, '').replace(/-+/g,'-');
      
      var buildPathElement = $('#build_path');
      if (!buildPathElement.data('manualEdit')) {
        $('#build_path').val(friendly);
      }
      
      var buildHashtagElement = $('#build_hashtag');
      if (!buildHashtagElement.data('manualEdit')) {
        $('#build_hashtag').val(friendly);
      }
    });
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