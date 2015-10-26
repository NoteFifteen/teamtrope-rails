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
