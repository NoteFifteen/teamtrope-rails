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

function submitForm(form_id) {
    var form = $("#" + form_id);

    if(form.valid) {
        form.submit();
    }
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

    // ebook initiative version - I really don't like doing this I would rather
    // set the id's in here dynamically I attempted to do the following but it
    // through an undefined error.
    // progress_bar_target: function() {
    //  return $('#ebook_published_file_epub_uploads_container')
    //}
    // I was going to determine the prefix (ebook|netgalley)based on the hidden
    // div I had included in the page.
    // Epub File
    $('#ebook_published_file_epub_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#ebook_published_file_epub_uploads_container'),
            before_add: function(file) {
                if (/(\.epub)$/i.test(file.name) || (/(epub)$/i.test(file.name)) || (/(docx?)$/i.test(file.name))) {
                    return true;
                } else {
                    alert('File type must be .epub');
                    return false;
                }
            }
        }
    );

    $('#ebook_published_file_epub_s3_uploader').bind('s3_upload_complete', function(e, content) {
        $('#submit_ebook_only_incentive_fake').removeAttr('disabled').removeClass('disabled');
        $('#uploaded_ebook_only_incentive_epub').text('true');
    });

    $('#ebook_published_file_epub_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    // Epub File - Netgalley Version
    $('#netgalley_published_file_epub_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#netgalley_published_file_epub_uploads_container'),
            before_add: function(file) {
                if (/(\.epub)$/i.test(file.name) || (/(epub)$/i.test(file.name)) || (/(docx?)$/i.test(file.name))) {
                    return true;
                } else {
                    alert('File type must be .epub');
                    return false;
                }
            }
        }
    );
    $('#netgalley_published_file_epub_s3_uploader').bind('s3_upload_complete', function(e, content) {
        $('#submit_netgalley_submission_fake').removeAttr('disabled').removeClass('disabled');
        $('#uploaded_netgalley_epub').text('true');
    });
    $('#netgalley_published_file_epub_s3_uploader').bind('s3_upload_failed', function(e, content) {
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
