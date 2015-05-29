// assets/javascripts/cover_concepts.js

/**
 * This file contains javascript relating to some if not all of the Cover Concept related forms
 */

/** Upload Cover Concept Form **/
$(function() {

    // PDF File
    $('#cover_concept_image_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_concept_image_uploads_container'),
            before_add: function (file) {
                if (/(jpe?g)$/i.test(file.type)) {
                    return true;
                } else {
                    alert('File type must be .jpg');
                    return false;
                }
            }

        }
    );
    $('#cover_concept_image_s3_uploader').bind('s3_upload_failed', function (e, content) {
        return alert(content.filename + ' failed to upload');
    });
});

/** Add Image / Stock Cover Image Form **/
$(function() {

    // PDF File
    $('#stock_cover_image_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#stock_cover_image_uploads_container'),
            before_add: function (file) {
                if (/(application\/zip|image\/(png|jpe?g))$/i.test(file.type)) {
                    return true;
                } else {
                    alert('File type must be .jpg, .png, or .zip');
                    return false;
                }
            }

        }
    );
    $('#stock_cover_image_s3_uploader').bind('s3_upload_failed', function (e, content) {
        return alert(content.filename + ' failed to upload');
    });
});
