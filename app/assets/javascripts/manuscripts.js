// assets/javascripts/manuscripts.js

/**
 * This file contains javascript relating to some if not all of the Manuscript related forms
 */

/** Upload Original Manuscript Form **/
$(function() {

    // PDF File
    $('#original_manuscript_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#original_manuscript_uploads_container'),
            before_add: function (file) {
                // Same as Constants::DefaultContentTypeDocumentParams
                //if (/(application\/msword|application\/vnd\.openxmlformats-officedocument\.wordprocessingml.document|text\/plain)$/i.test(file.type) || (/(doc?x)$/i.test(file.name))) {
                    return true;
                //} else {
                //    alert('File type must be .doc or .docx');
                //    return false;
                //}
            }

        }
    );
    $('#original_manuscript_s3_uploader').bind('s3_upload_failed', function (e, content) {
        return alert(content.filename + ' failed to upload');
    });
});

/** Upload Edited Manuscript Form **/
$(function() {

    // PDF File
    $('#edited_manuscript_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#edited_manuscript_uploads_container'),
            before_add: function (file) {
                // Same as Constants::DefaultContentTypeDocumentParams
                //if (/(application\/msword|application\/vnd\.openxmlformats-officedocument\.wordprocessingml.document|text\/plain)$/i.test(file.type) || (/(doc?x)$/i.test(file.name))) {
                    return true;
                //} else {
                //    alert('File type must be .doc or .docx');
                //    return false;
                //}
            }

        }
    );
    $('#edited_manuscript_s3_uploader').bind('s3_upload_failed', function (e, content) {
        return alert(content.filename + ' failed to upload');
    });
});

/** Upload Proofread Reviewed Manuscript Form **/
$(function() {

    // PDF File
    $('#proofread_reviewed_manuscript_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#proofread_reviewed_manuscript_uploads_container'),
            before_add: function (file) {
                    return true;
            }

        }
    );
    $('#proofread_reviewed_manuscript_s3_uploader').bind('s3_upload_failed', function (e, content) {
        return alert(content.filename + ' failed to upload');
    });
});


/** Proofed Edited Manuscript Form **/
$(function() {

    // PDF File
    $('#proofed_manuscript_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#proofed_manuscript_uploads_container'),
            before_add: function (file) {
                // Same as Constants::DefaultContentTypeDocumentParams
                //if (/(application\/msword|application\/vnd\.openxmlformats-officedocument\.wordprocessingml.document|text\/plain)$/i.test(file.type) || (/(doc?x)$/i.test(file.name))) {
                    return true;
                //} else {
                //    alert('File type must be .doc or .docx');
                //    return false;
                //}
            }

        }
    );
    $('#proofed_manuscript_s3_uploader').bind('s3_upload_failed', function (e, content) {
        return alert(content.filename + ' failed to upload');
    });

});

function submitProofreadManuscriptForm()
{
    var form = $("#submit_proofread");
    if(form.valid) {
        form.submit();
    }
}
