// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var WatchMeMakeThis = {
  fancyboxify:function() {
    $('#build_images a[rel=build_group]').fancybox({'cyclic':true,'titlePosition':'over','transitionIn':'elastic','transitionOut':'elastic'});
    $('#build_images a.more').unbind('click').click(function() {
      $(this).parents('li.image').find('a.thumb').click();
      return false;
    });
  },
  
  autoFillFields:function(from, to) {
    // watch for manual keypresses so we don't auto update this
    $.each(to, function() {
      $(this).data('manualEdit',false).bind('keypress', function() {
        $(this).data('manualEdit', true);
      })
    });
    
    from.bind('keyup', function() {
      var friendly = $(this).val().toLowerCase().replace(/[^0-9a-zA-Z-_'"!\.]/g,'-').replace(/['"!\.]/g, '').replace(/-+/g,'-');
      
      $.each(to, function() {
        if (!$(this).data('manualEdit')) {
          $(this).val(friendly);
        }
      });
    });
  },
  
  ajaxNewImage:function(image) {
    // remove any "no images" placeholder
    $('.none, .intro').fadeOut();
    // add the new image to the page
    var newImageElement = $("#image_new").clone();
    // update the container
    newImageElement.attr('id', 'image_'+image.id);
    // update thumbnail image
    newImageElement.find('img').attr('src', image.url_small);
    // update link surrounding image
    newImageElement.find('a.thumb').attr('href', image.url_large).attr('rel', 'build_group').attr('title',image.description);
    // update description
    newImageElement.find('.description').text(image.description);
    // update description form action
    newImageElement.find('form').attr('action', image.path);
    // update upload time
    newImageElement.find('.added').text('Added just now');
    // update delete link
    newImageElement.find('.delete').attr('href', image.path);
    // add to the page
    $('#image_new').after(newImageElement);
    // update fancybox so this image gets added to the rotation
    WatchMeMakeThis.fancyboxify();
    // update inline description editing
    WatchMeMakeThis.setupImageDescriptionEditing();
    // and finally show it
    newImageElement.delay(1000).fadeIn(500);
  },
  
  checkForNewImages:function(path) {
    setInterval(function() {
      var latestId = $('#build_images .image')[1] ? $('#build_images .image')[1].id.split('_')[1] : null;
      $.get(path+'.json', 
            {'since':latestId},
            function(data) {
              console.info(data);
              if (data.length > 0) {
                $.each(data, function() {
                  WatchMeMakeThis.ajaxNewImage(this);
                })
              }
            }
          );
    }, 10000);
  },
  
  signupStylePreview:function(select, preview) {
    select.change(function() {
      var style = $.parseJSON(select.find('option:selected').attr('data-style'));
      preview.find('.header').css('backgroundColor', style.header_background).css('color', style.header_text_color);
      preview.find('.body').css('backgroundColor', style.body_background).css('color', style.body_text_color).css('borderColor', style.header_background);
    });
    select.change();
  },
  
  // handlers for inline editing of an image description
  setupImageDescriptionEditing:function() {
    $('.image .description').unbind('click').click(function() {
      $(this).hide();
      $(this).siblings('form').show().find('textarea').focus();
      return false;
    }).siblings('form').find('a').unbind('click').click(function() {
      $(this).parent().hide().siblings('.description').show();
      return false;
    }).end().unbind('ajax:success').bind('ajax:success', function(event, data, xhr) {
      $(this).siblings('.description').text(data.description);
      $(this).hide().siblings('.description').show();
    });
  }
  
};

$(document).ready(function() {

  // switch site dropdown
  $('header nav select').change(function() {
    location.href = '/' + this.value;
  });

  // delete an image
  $('.image .delete').live('ajax:success', function() {
    $(this).parents('li.image').fadeOut();
  });

});
