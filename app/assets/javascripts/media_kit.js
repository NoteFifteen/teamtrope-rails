// assets/javascripts/media_kit.js

/**
 * This is used for form validation to ensure that all required file_types have been uploaded before
 * enabling the submit button.
 */
var media_kit_uploaded_types = [];

function requiredMediaKitDocumentUnlockSubmit() {
    var has_document = false;

    $(media_kit_uploaded_types).each(function(id, value) {
        if(value == 'document') {
            has_document = true;
        }
    });

    if(has_document) {
        $('#media_kit_submit_button').removeAttr('disabled').removeClass('disabled');
        return true;
    }

    return false;
}


$(function() {

    // document File
    $('#media_kit_document_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#media_kit_document_uploads_container'),
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
    $('#media_kit_document_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });
});
