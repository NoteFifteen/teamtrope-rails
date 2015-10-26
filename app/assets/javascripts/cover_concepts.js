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
