// assets/javascripts/published_file.js

/**
 * This is used for form validation to ensure that all required file_types have been uploaded before
 * enabling the submit button.
 */
var published_books_uploaded_types = [];

function requiredPublishBooksUnlockSubmit() {
    var has_mobi = false;
    var has_epub = false;

    $(published_books_uploaded_types).each(function(id, value) {
        if(value == 'mobi') {
            has_mobi = true;
        }
        if(value == 'epub') {
            has_epub = true;
        }
    });

    if(has_epub && has_mobi) {
        $('#published_file_submit_button').removeAttr('disabled').removeClass('disabled');
        return true;
    }

    return false;
}

$(function() {

    // Mobi File
    $('#published_file_mobi_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#published_file_mobi_uploads_container'),
            before_add: function(file) {
                if (/(application\/octet-stream)$/i.test(file.type) || (/(mobi)$/i.test(file.name))) {
                    return true;
                } else {
                    alert('File type must be .mobi');
                    return false;
                }
            }
        }
    );
    $('#published_file_mobi_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    // Epub File
    $('#published_file_epub_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#published_file_epub_uploads_container'),
            before_add: function(file) {
                if (/(\.epub)$/i.test(file.name) || (/(epub)$/i.test(file.name))) {
                    return true;
                } else {
                    alert('File type must be .epub');
                    return false;
                }
            }
        }
    );
    $('#published_file_epub_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    // Optional PDF File
    $('#published_file_pdf_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#published_file_pdf_uploads_container'),
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
    $('#published_file_pdf_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

});