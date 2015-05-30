// assets/javascripts/final_covers.js
var cover_template_uploaded_files = [];

function requiredCoverTemplateFilesUnlockSubmit() {
  var has_ebook = false;
  var has_createspace = false;
  var has_lightning_source = false;

  $(cover_template_uploaded_files).each(function(id, value) {
    if(value == 'ebook_front_cover') {
      has_ebook = true;
    }
    if(value == 'createspace_cover') {
      has_createspace = true;
    }
    if(value == 'lightning_source_cover') {
      has_lightning_source = true;
    }
  });

  if(has_ebook && has_createspace && has_lightning_source) {
    $('#cover_template_submit_button').removeAttr('disabled').removeClass('disabled');
    return true;
  }

  return false;
}

$(function() {
    // ebook front cover
    $('#cover_template_ebook_front_cover_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_template_ebook_front_cover_uploads_container'),
            before_add: function(file) {
                if (/(application\/zip|image\/jpeg|image\/pjpeg)$/i.test(file.type)) {
                    return true;
                } else {
                    alert('File type must be .jpg');
                    return false;
                }
            }
    }
    );

    // createspace cover
    $('#cover_template_ebook_front_cover_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    $('#cover_template_createspace_cover_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_template_createspace_cover_uploads_container'),
            before_add: function(file) {
                if (/(application\/pdf)$/i.test(file.type) || (/(pdf)$/i.test(file.name))) {
                    return true;
                } else {
                    alert('File type must be .pdf');
                    return false;
                }
            }
    }
    );
    $('#cover_template_createspace_cover_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    // lightning source cover
    $('#cover_template_lightning_source_cover_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_template_lightning_source_cover_uploads_container'),
            before_add: function(file) {
                if (/(application\/pdf)$/i.test(file.type) || (/(pdf)$/i.test(file.name))) {
                    return true;
                } else {
                    alert('File type must be .pdf');
                    return false;
                }
            }
    }
    );
    $('#cover_template_lightning_source_cover_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    // alternative cover
    $('#cover_template_alternative_cover_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_template_alternative_cover_uploads_container'),
            before_add: function(file) {
                if (/(application\/pdf)$/i.test(file.type) || (/(pdf)$/i.test(file.name))) {
                    return true;
                } else {
                    alert('File type must be .pdf');
                    return false;
                }
            }
    }
    );
    $('#cover_template_alternative_cover_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });
});
