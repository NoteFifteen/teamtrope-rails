// assets/javascripts/final_covers.js
var cover_template_uploaded_files = [];

function requiredCoverTemplateFilesUnlockSubmit() {
  unlock = ['raw_cover', 'ebook_front_cover', 'createspace_cover', 'lightning_source_cover'].every(function(upload) {
      return cover_template_uploaded_files.indexOf(upload) > -1
  })
  if (unlock) {
      $('#cover_template_submit_button').removeAttr('disabled').removeClass('disabled');
  }
  return unlock;
}

// Add a form validator
$('#cover_template_ebook_front_cover_s3_uploader').validate({
    rules: {
        'checklist_0': { required: true },
        'checklist_1': { required: true },
        'checklist_2': { required: true },
        'checklist_3': { required: true },
        'checklist_4': { required: true }
    },
    messages: {
        'checklist_0': 'All checklist items must be signed off before proceeding',
        'checklist_1': 'All checklist items must be signed off before proceeding',
        'checklist_2': 'All checklist items must be signed off before proceeding',
        'checklist_3': 'All checklist items must be signed off before proceeding',
        'checklist_4': 'All checklist items must be signed off before proceeding'
    }
});

// Add a form validator (this is for Update PSD...blech)
$('#cover_template_raw_cover_s3_uploader').validate({
    rules: {
        'checklist_0': { required: true }
    },
    messages: {
        'checklist_0': 'Checklist item must be signed off before proceeding'
    }
});

$(function() {
    // raw front cover
    $('#cover_template_raw_cover_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_template_raw_cover_uploads_container'),
            // we can't count on file.type because some browsers suck :-P
            before_add: function(file) {
                if (/\.(psd|ai)$/i.test(file.name)) {
                    return true;
                } else {
                    alert('File type must be .psd or .ai');
                    return false;
                }
            }
    }
    );
    $('#cover_template_raw_cover_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

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
    $('#cover_template_ebook_front_cover_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    // createspace cover
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

    // font license
    // (no constraint on file suffix for font files, or zips of them)
    $('#cover_template_font_license_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_template_font_license_uploads_container')
        }
    );
    $('#cover_template_font_license_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });
});
