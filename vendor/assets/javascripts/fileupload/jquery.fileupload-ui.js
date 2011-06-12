/*
 * jQuery File Upload User Interface Plugin 5.0
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://creativecommons.org/licenses/MIT/
 */

/*jslint nomen: false, unparam: false, regexp: false */
/*global window, document, URL, webkitURL, FileReader, jQuery */

(function ($) {
    'use strict';
    
    // The UI version extends the basic fileupload widget and adds
    // a complete user interface based on the given upload/download
    // templates.
    $.widget('blueimpUI.fileupload', $.blueimp.fileupload, {
        
        options: {
            // By default, files added to the widget are uploaded as soon
            // as the user clicks on the start buttons. To enable automatic
            // uploads, set the following option to true:
            autoUpload: true,
            // The following option limits the number of files that are
            // allowed to be uploaded using this widget:
            maxNumberOfFiles: undefined,
            // The maximum allowed file size:
            maxFileSize: undefined,
            // The minimum allowed file size:
            minFileSize: 1,
            // The regular expression for allowed file types, matches
            // against either file type or file name:
            acceptFileTypes:  /(gif|jpeg|jpg|png)$/i,
            // The regular expression to define for which files a preview
            // image is shown, matched against the file type:
            previewFileTypes: /^image\/(gif|jpeg|jpg|png)$/,
            // The maximum width of the preview images:
            previewMaxWidth: 50,
            // The maximum height of the preview images:
            previewMaxHeight: 50,
            // By default, preview images are displayed as canvas elements
            // if supported by the browser. Set the following option to false
            // to alwqys display preview images as img elements:
            previewAsCanvas: true,
            // Image links with a "rel" attribute starting with "gallery"
            // (e.g. rel="gallery" or rel="gallery[name]") are opened in a
            // jQuery UI dialog. If the following option is true and the browser
            // supports it, the image is displayed as canvas elements:
            openImageAsCanvas: true,
            // The file upload template that is given as first argument to the
            // jQuery.tmpl method to render the file uploads:
            uploadTemplate: $('#template-upload'),
            // The file download template, that is given as first argument to the
            // jQuery.tmpl method to render the file downloads:
            downloadTemplate: $('#template-download'),
            // The expected data type of the upload response, sets the dataType
            // option of the $.ajax upload requests:
            dataType: 'json',
            
            // The add callback is invoked as soon as files are added to the fileupload
            // widget (via file input selection, drag & drop or add API call).
            // See the basic file upload widget for more information:
            add: function (e, data) {
                var that = $(this).data('fileupload');
                that._adjustMaxNumberOfFiles(-data.files.length);
                data.context = that._renderUpload(data.files)
                    .appendTo($(this).find('.files')).fadeIn(function () {
                        // Fix for IE7 and lower:
                        $(this).show();
                    }).data('data', data);
                data.isValidated = true;
                if (that.options.autoUpload || data.autoUpload) {
                    data.context.find('.start button').click();
                }
            },
            // Callback for the start of each file upload request:
            send: function (e, data) {
                if (!data.isValidated) {
                    var that = $(this).data('fileupload'),
                        hasErrors = false;
                    that._adjustMaxNumberOfFiles(-data.files.length);
                    $.each(data.files, function (index, file) {
                        file.error = that._hasError(file);
                        if (file.error) {
                            hasErrors = true;
                        }
                    });
                    if (hasErrors) {
                        return false;
                    }
                }
                if (data.context && data.dataType &&
                        data.dataType.substr(0, 6) === 'iframe') {
                    // Iframe Transport does not support progress events.
                    // In lack of an indeterminate progress bar, we set
                    // the progress to 100%, showing the full animated bar:
                    data.context.find('.ui-progressbar').progressbar(
                        'value',
                        parseInt(100, 10)
                    );
                }
            },
            // Callback for successful uploads:
            done: function (e, data) {
                var images = data.result;
                var that = $(this).data('fileupload');
                if (data.context) {
                    data.context.each(function (index) {
                        var file = ($.isArray(data.result) &&
                                data.result[index]) || {error: 'emptyResult'};
                        $(this).fadeOut(function () {
                            that._renderDownload([file])
                                .css('display', 'none')
                                .replaceAll(this)
                                .fadeIn(function () {
                                    // Fix for IE7 and lower:
                                    $(this).show();
                                });
                        });
                    });
                    
                  WatchMeMakeThis.ajaxNewImage(images);
                  
                } else {
                  alert("no context");
                    that._renderDownload(data.result)
                        .css('display', 'none')
                        .appendTo($(this).find('.files'))
                        .fadeIn(function () {
                            // Fix for IE7 and lower:
                            $(this).show();
                        });
                }
            },
            // Callback for failed (abort or error) uploads:
            fail: function (e, data) {
                var that = $(this).data('fileupload');
                that._adjustMaxNumberOfFiles(data.files.length);
                if (data.context) {
                    data.context.each(function (index) {
                        $(this).fadeOut(function () {
                            if (data.errorThrown !== 'abort') {
                                var file = data.files[index];
                                file.error = file.error || data.errorThrown
                                    || true;
                                that._renderDownload([file])
                                    .css('display', 'none')
                                    .replaceAll(this)
                                    .fadeIn(function () {
                                        // Fix for IE7 and lower:
                                        $(this).show();
                                    });
                            } else {
                                data.context.remove();
                            }
                        });
                    });
                } else if (data.errorThrown !== 'abort') {
                    that._adjustMaxNumberOfFiles(-data.files.length);
                    data.context = that._renderUpload(data.files)
                        .css('display', 'none')
                        .appendTo($(this).find('.files'))
                        .fadeIn(function () {
                            // Fix for IE7 and lower:
                            $(this).show();
                        }).data('data', data);
                }
            },
            // Callback for upload progress events:
            progress: function (e, data) {
                if (data.context) {
                    data.context.find('.ui-progressbar').progressbar(
                        'value',
                        parseInt(data.loaded / data.total * 100, 10)
                    );
                }
            },
            // Callback for global upload progress events:
            progressall: function (e, data) {
                $(this).find('.fileupload-progressbar').progressbar(
                    'value',
                    parseInt(data.loaded / data.total * 100, 10)
                );
            },
            // Callback for uploads start, equivalent to the global ajaxStart event:
            start: function () {
                $(this).find('.fileupload-progressbar')
                    .progressbar('value', 0).fadeIn();
            },
            // Callback for uploads stop, equivalent to the global ajaxStop event:
            stop: function () {
                $(this).find('.fileupload-progressbar').fadeOut();
            },
            // Callback for file deletion:
            destroy: function (e, data) {
                var that = $(this).data('fileupload');
                if (data.url) {
                    $.ajax(data)
                        .success(function () {
                            that._adjustMaxNumberOfFiles(1);
                            $(this).fadeOut(function () {
                                $(this).remove();
                            });
                        });
                } else {
                    data.context.fadeOut(function () {
                        $(this).remove();
                    });
                }
            },
            dragover:function(e) {
              $('#fileupload').addClass('dragover');
            },
            dragleave:function(e) {
              $('#fileupload').removeClass('dragover');
            },
           drop:function(e) {
              $('#fileupload').removeClass('dragover');
            }
        },

        _scaleImage: function (img, maxWidth, maxHeight, noCanvas) {
            var canvas = document.createElement('canvas'),
                scale = Math.min(
                    (maxWidth || img.width) / img.width,
                    (maxHeight || img.height) / img.height
                );
            if (scale > 1) {
                scale = 1;
            }
            img.width = parseInt(img.width * scale, 10);
            img.height = parseInt(img.height * scale, 10);
            if (noCanvas || !canvas.getContext) {
                return img;
            }
            canvas.width = img.width;
            canvas.height = img.height;
            canvas.getContext('2d')
                .drawImage(img, 0, 0, img.width, img.height);
            return canvas;
        },

        // Loads an image for a given File object,
        // invokes the callback with an img or canvas element as parameter:
        _loadImage: function (file, callBack, maxWidth, maxHeight, imageTypes, noCanvas) {
            var that = this,
                undef = 'undefined',
                img,
                urlAPI,
                fileReader;
            if (!imageTypes || imageTypes.test(file.type)) {
                img = document.createElement('img');
                urlAPI = (typeof URL !== undef && URL) ||
                    (typeof webkitURL !== undef && webkitURL);
                if (urlAPI && urlAPI.createObjectURL) {
                    img.onload = function () {
                        urlAPI.revokeObjectURL(this.src);
                        callBack(that._scaleImage(img, maxWidth, maxHeight, noCanvas));
                    };
                    img.src = urlAPI.createObjectURL(file);
                    return true;
                }
                if (typeof FileReader !== undef &&
                        FileReader.prototype.readAsDataURL) {
                    img.onload = function () {
                        callBack(that._scaleImage(img, maxWidth, maxHeight, noCanvas));
                    };
                    fileReader = new FileReader();
                    fileReader.onload = function (e) {
                        img.src = e.target.result;
                    };
                    fileReader.readAsDataURL(file);
                    return true;
                }
            }
            return false;
        },

        // Opens the image of the given link in a jQuery UI dialog
        // and provides a simple gallery functionality:
        _openImageDialog: function (link, callback, noCanvas) {
            var that = this,
                rel = link.rel,
                links = $('a[rel="' + rel + '"]'),
                nextLink,
                loader = $('<div class="loading"></div>')
                    .hide().appendTo(that.element).fadeIn();
            links.each(function (index) {
                if ((links[index - 1] === link || links[index - 2] === link) &&
                        this.href !== link.href) {
                    nextLink = this;
                    return false;
                }
            });
            if (!nextLink) {
                nextLink = links[0];
            }
            $('<img>').bind('load error', function (e) {
                var dialog = $('<div class="' + rel.replace(/\W/g, '-') +
                        '-dialog"></div>'),
                    closeDialog = function () {
                        dialog.dialog('close'); 
                    };
                if (e.type === 'error') {
                    noCanvas = true;
                    dialog.addClass('missing-image');
                }
                dialog.bind({
                    click: function () {
                        dialog.unbind('click').fadeOut();
                        if (nextLink.href !== link.href) {
                            that._openImageDialog(nextLink, closeDialog, noCanvas);
                        } else {
                            closeDialog();
                        }
                    },
                    dialogopen: function () {
                        if (typeof callback === 'function') {
                            callback();
                        }
                        $('.ui-widget-overlay').click(closeDialog);
                    },
                    dialogclose: function () {
                        $(this).remove();
                    }
                }).css('cursor', 'pointer').append(
                    that._scaleImage(
                        this,
                        $(window).width() - 100,
                        $(window).height() - 100,
                        noCanvas
                    )
                ).appendTo(that.element).dialog({
                    modal: true,
                    resizable: false,
                    width: 'auto',
                    height: 'auto',
                    show: 'fade',
                    hide: 'fade',
                    title: decodeURIComponent(this.src.split('/').pop())
                });
                loader.fadeOut(function () {
                    loader.remove();
                });
            }).prop('src', link.href);
            // Preload the next image:
            $('<img>').prop('src', nextLink.href);
        },

        // Link handler, that allows to download files
        // by drag & drop of the links to the desktop:
        _enableDragToDesktop: function () {
            var link = $(this),
                url = link.prop('href'),
                name = decodeURIComponent(url.split('/').pop())
                    .replace(/:/g, '-'),
                type = 'application/octet-stream';
            link.bind('dragstart', function (e) {
                try {
                    e.originalEvent.dataTransfer.setData(
                        'DownloadURL',
                        [type, name, url].join(':')
                    );
                } catch (err) {}
            });
        },

        _adjustMaxNumberOfFiles: function (operand) {
            if (typeof this.options.maxNumberOfFiles === 'number') {
                this.options.maxNumberOfFiles += operand;
            }
        },

        _formatFileSize: function (file) {
            if (typeof file.size !== 'number') {
                return '';
            }
            if (file.size >= 1000000000) {
                return (file.size / 1000000000).toFixed(2) + ' GB';
            }
            if (file.size >= 1000000) {
                return (file.size / 1000000).toFixed(2) + ' MB';
            }
            return (file.size / 1000).toFixed(2) + ' KB';
        },

        _hasError: function (file) {
            if (file.error) {
                return file.error;
            }
            // The number of added files is subtracted from
            // maxNumberOfFiles before validation, so we check if
            // maxNumberOfFiles is below 0 (instead of below 1):
            if (this.options.maxNumberOfFiles < 0) {
                return 'maxNumberOfFiles';
            }
            // Files are accepted if either the file type or the file name
            // matches against the acceptFileTypes regular expression, as
            // only browsers with support for the File API report the type:
            if (!(this.options.acceptFileTypes.test(file.type) ||
                    this.options.acceptFileTypes.test(file.name))) {
                return 'acceptFileTypes';
            }
            if (this.options.maxFileSize &&
                    file.size > this.options.maxFileSize) {
                return 'maxFileSize';
            }
            if (typeof file.size === 'number' &&
                    file.size < this.options.minFileSize) {
                return 'minFileSize';
            }
            return null;
        },

        _uploadTemplateHelper: function (file) {
            file.sizef = this._formatFileSize(file);
            file.error = this._hasError(file);
            return file;
        },

        _renderUpload: function (files) {
            var that = this,
                options = this.options,
                tmpl = $.tmpl(
                    this.options.uploadTemplate,
                    $.map(files, function (file) {
                        return that._uploadTemplateHelper(file);
                    })
                );
            if (!(tmpl instanceof $)) {
                return $();
            }
            tmpl.css('display', 'none');
            tmpl.find('.progress div').first().progressbar();
            tmpl.find('.start button').hide().first().show().button({
                text: false,
                icons: {primary: 'ui-icon-circle-arrow-e'}
            });
            tmpl.find('.cancel button').hide().first().show().button({
                text: false,
                icons: {primary: 'ui-icon-cancel'}
            });
            tmpl.find('.preview').each(function (index, node) {
                that._loadImage(
                    files[index],
                    function (img) {
                        $(img).hide().appendTo(node).fadeIn();
                    },
                    options.previewMaxWidth,
                    options.previewMaxHeight,
                    options.previewFileTypes,
                    !options.previewAsCanvas
                );
            });
            return tmpl;
        },

        _downloadTemplateHelper: function (file) {
            file.sizef = this._formatFileSize(file);
            return file;
        },
        
        _renderDownload: function (files) {
            var that = this,
                tmpl = $.tmpl(
                    this.options.downloadTemplate,
                    $.map(files, function (file) {
                        return that._downloadTemplateHelper(file);
                    })
                );
            if (!(tmpl instanceof $)) {
                return $();
            }
            tmpl.css('display', 'none');
            tmpl.find('.delete button').button({
                text: false,
                icons: {primary: 'ui-icon-trash'}
            });
            tmpl.find('a').each(this._enableDragToDesktop);
            return tmpl;
        },
        
        _startHandler: function (e) {
            e.preventDefault();
            var tmpl = $(this).closest('.template-upload'),
                data = tmpl.data('data');
            if (data && data.submit) {
                data.jqXHR = data.submit();
                $(this).fadeOut();
            }
        },
        
        _cancelHandler: function (e) {
            e.preventDefault();
            var tmpl = $(this).closest('.template-upload'),
                data = tmpl.data('data') || {};
            if (!data.jqXHR) {
                data.errorThrown = 'abort';
                e.data.fileupload._trigger('fail', e, data);
            } else {
                data.jqXHR.abort();
            }
        },
        
        _deleteHandler: function (e) {
            e.preventDefault();
            var button = $(this);
            e.data.fileupload._trigger('destroy', e, {
                context: button.closest('.template-download'),
                url: button.attr('data-url'),
                type: button.attr('data-type'),
                dataType: e.data.fileupload.options.dataType
            });
        },

        _imageLinkHandler: function (e) {
            e.preventDefault();
            var fu = e.data.fileupload;
            fu._openImageDialog(this, null, !fu.options.openImageAsCanvas);
        },
        
        _initEventHandlers: function () {
            $.blueimp.fileupload.prototype._initEventHandlers.call(this);
            var filesList = this.element.find('.files'),
                eventData = {fileupload: this};
            filesList.find('.start button')
                .live(
                    'click.' + this.options.namespace,
                    eventData,
                    this._startHandler
                );
            filesList.find('.cancel button')
                .live(
                    'click.' + this.options.namespace,
                    eventData,
                    this._cancelHandler
                );
            filesList.find('.delete button')
                .live(
                    'click.' + this.options.namespace,
                    eventData,
                    this._deleteHandler
                );
            filesList.find('a[rel^=gallery]')
                .live(
                    'click.' + this.options.namespace,
                    eventData,
                    this._imageLinkHandler
                );
        },
        
        _destroyEventHandlers: function () {
            var filesList = this.element.find('.files');
            filesList.find('a[rel^=gallery]')
                .die('click.' + this.options.namespace);
            filesList.find('.start button')
                .die('click.' + this.options.namespace);
            filesList.find('.cancel button')
                .die('click.' + this.options.namespace);
            filesList.find('.delete button')
                .die('click.' + this.options.namespace);
            $.blueimp.fileupload.prototype._destroyEventHandlers.call(this);
        },

        _initFileUploadButtonBar: function () {
            var fileUploadButtonBar = this.element.find('.fileupload-buttonbar'),
                filesList = this.element.find('.files'),
                ns = this.options.namespace;
            $('.fileinput-button').each(function () {
                var fileInput = $(this).find('input:file').detach();
                //$(this).button({icons: {primary: 'ui-icon-plusthick'}})
                //  .append(fileInput);
                $(this).button().append(fileInput);
            });
            fileUploadButtonBar.find('.start')
                .button({icons: {primary: 'ui-icon-circle-arrow-e'}})
                .bind('click.' + ns, function (e) {
                    e.preventDefault();
                    filesList.find('.start button').click();
                });
            fileUploadButtonBar.find('.cancel')
                .button({icons: {primary: 'ui-icon-cancel'}})
                .bind('click.' + ns, function (e) {
                    e.preventDefault();
                    filesList.find('.cancel button').click();
                });
            fileUploadButtonBar.find('.delete')
                .button({icons: {primary: 'ui-icon-trash'}})
                .bind('click.' + ns, function (e) {
                    e.preventDefault();
                    filesList.find('.delete button').click();
                });
        },
        
        _destroyFileUploadButtonBar: function () {
            $('.fileinput-button').each(function () {
                var fileInput = $(this).find('input:file').detach();
                $(this).button('destroy')
                    .append(fileInput);
            });
            this.element.find('.fileupload-buttonbar').find('button')
                .unbind('click.' + this.options.namespace)
                .button('destroy');
        },

        _create: function () {
            $.blueimp.fileupload.prototype._create.call(this);
            this.element.addClass('ui-widget');
            this._initFileUploadButtonBar();
            this.element.find('.fileupload-progressbar')
                .hide().progressbar();
        },
        
        destroy: function () {
            this.element.find('.fileupload-progressbar')
                .progressbar('destroy');
            this._destroyFileUploadButtonBar();
            this.element.removeClass('ui-widget');
            $.blueimp.fileupload.prototype.destroy.call(this);
        }

    });

}(jQuery));