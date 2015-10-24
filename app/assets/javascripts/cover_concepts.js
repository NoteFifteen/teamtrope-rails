// assets/javascripts/cover_concepts.js

/**
 * This file contains javascript relating to some if not all of the Cover Concept related forms
 */


$(document).ready(function() {

    // deal with "Other"
    $('#cover_concept_image_source_other_input').focus(function() {
        $('#cover_concept_image_source_other').prop('checked', true);
        if (this.value == 'Other') {
            this.value = '';
        }
    });
    $('#cover_concept_image_source_other_input').blur(function() {
        if (this.value == '') {
            this.value = 'Other';
        }
    });

    $('#cover_concept_image_source_other').change(function() {
        if (this.checked) {
            $('#cover_concept_image_source_other_input').focus();
        }
    });

    // validation
    $('#cover_concept_upload').validate({
        errorElement: "div",
        errorPlacement: function(error, element) {
            error.appendTo("div#cover_concept_upload_errors");
        },
        rules: {
            'project[cover_concepts][image_source]': {
                required: true
            },
            'project[cover_concepts][signoffs][]': {
                required: true,
                minlength: 2
            },
            'cover_concept_image_source_other_input': {
                otherSourceValid: true
            }
        },
        messages: {
            'project[cover_concepts][image_source]': {
                required: 'You must specify a source for the cover concept image.'
            },
            'project[cover_concepts][signoffs][]': {
                required: 'You must confirm all the signoff items.',
                minlength: 'You must confirm all the signoff items.'
            }
        }
    });

    $.validator.addMethod("otherSourceValid", function(value) {
        var checked =  $('#cover_concept_image_source_other').is(':checked');
        return !checked || (value != "Other" && value != "")
    }, 'Please enter a source when selecting "Other".');
});



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
                if (/(application\/zip|image\/(png|jpe?g))$/i.test(file.type)  || (/(png|jp?g|zip)$/i.test(file.name))) {
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
