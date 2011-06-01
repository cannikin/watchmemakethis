// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var WatchMeMakeThis = {
  fancyboxify:function() {
    $('#build_images a[rel=build_group]').fancybox({
      'cyclic':true,
      'titlePosition':'over',
      'transitionIn':'elastic',
      'transitionOut':'elastic',
      onStart:function(items,index,opts) {
        var obj = $(items[index]).parent()
        if (obj.hasClass('drag_sort')) {
          obj.removeClass('drag_sort');
          return false;
        }
      }
    });
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
    newImageElement.attr('id', 'image_'+image.id).attr('data-id', image.id).attr('data-position', image.position);
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
      var lastPosition = $('#build_images .image[data-position]').first().attr('data-position');
      $.get(path+'.json', 
            {'since':lastPosition},
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
      console.info($.parseJSON(select.find('option:selected').attr('data-style')));
      var style = $.parseJSON(select.find('option:selected').attr('data-style'));
      preview.find('.header').animate({'backgroundColor':style.header_background, 'color':style.header_text_color}, 250);
      preview.find('.body').animate({'backgroundColor':style.body_background, 'color':style.body_text_color, 'borderColor':style.header_background}, 250)
      preview.find('.image').animate({'borderColor':style.image_border.split(' ')[2]}, 250);
    });
    select.change();
  },
  
  // handlers for inline editing of an image description
  setupImageDescriptionEditing:function() {
    // show the edit form when the description is clicked
    $('.image .description').unbind('click').click(function() {
      $(this).hide();
      $(this).siblings('form').show().find('textarea').select();
      return false;
    // show the description box again when you click cancel
    }).siblings('form').find('a').unbind('click').click(function() {
      $(this).parent().hide().siblings('.description').show();
      return false;
    // update the description with the new text
    }).end().unbind('ajax:success').bind('ajax:success', function(event, data, xhr) {
      $(this).siblings('.description').text(data.description);
      $(this).hide().siblings('.description').show();
    // submit the form when you press enter
    }).find('textarea').bind('keypress', function(e) {  
      if (e.which == '13') {
        $(this).parent().submit();
        e.preventDefault();
      }
    });
  },
  
  makeSortable:function(url) {
    $('#build_images').sortable({
      start:function(e,ui) {
        ui.item.addClass('drag_sort');
      }, 
      stop:function(e,ui) {
        var images = [];
        $('#build_images li').each(function() {
          if ($(this).attr('data-id')) {
            images.push(parseInt($(this).attr('data-id')));
          }
        });
        $.ajax({
          url:url,
          type:'put',
          data:{'images':images}
        });
      }
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
