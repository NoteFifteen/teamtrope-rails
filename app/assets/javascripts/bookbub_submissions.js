/**
 * Validator Bindings & Rules
 *
 */
$(document).ready(function(){

    bookbub_validator = $('#bookbub_submission').validate({
        errorElement: 'span',
        errorClass: 'validationError',
        errorPlacement: function(error, element) {
            // Put the error to the right
            if(element.attr('type') === 'radio') {
                var label = $(element).closest('span');
                error.insertBefore(label);
            } else {
                error.insertBefore(element);
            }
        },
        rules: {
            'project[bookbub_submission_attributes][author]': {
                required: true
            },
            'project[bookbub_submission_attributes][title]': {
                required: true
            },
            'project[bookbub_submission_attributes][asin]': {
                required: true
            },
            'project[bookbub_submission_attributes][asin_linked_url]': {
                required: true
            },
            'project[bookbub_submission_attributes][current_price]': {
                required: true
            },
            'bookbub_past_6_months': {
                required: true
            },
            'bookbub_feature_past_30_days': {
                required: true
            },
            'project[bookbub_submission_attributes][num_reviews]': {
                required: true
            },
            'project[bookbub_submission_attributes][num_stars]': {
                required: true,
                reviewStarsValid: true
            },
            'project[bookbub_submissions_attributes][0][enrollment_date(1i)]': {
                required: true,
                enrollmentDateValid: true
            },
            'project[bookbub_submission_attributes][num_pages]': {
                required: true
            }
        },
        messages: {
            'project[bookbub_submission_attributes][author]': {
                required: 'Please provide an Author name'
            },
            'project[bookbub_submission_attributes][title]': {
                required: 'Please provide a Book Title name'
            },
            'project[bookbub_submission_attributes][asin]': {
                required: 'Please provide an Amazon ASIN'
            },
            'project[bookbub_submission_attributes][asin_linked_url]': {
                required: 'Please provide a link on Amazon for this ASIN'
            },
            'project[bookbub_submission_attributes][current_price]': {
                required: 'Please enter the current price'
            },
            'project[bookbub_submissions_attributes][0][enrollment_date(1i)]': {
                required: 'Please select a valid date'
            },
            'bookbub_past_6_months': {
                required: 'Please answer'
            },
            'bookbub_feature_past_30_days': {
                required: 'Please answer'
            },
            'project[bookbub_submission_attributes][num_reviews]': {
                required: 'Please answer'
            },
            'project[bookbub_submission_attributes][num_stars]': {
                required: 'Please answer'
            },
            'project[bookbub_submission_attributes][num_pages]': {
                required: 'Please answer'
            }
        }
    });

    // Custom validator for the number of review stars
    $.validator.addMethod("reviewStarsValid", function(value, element, params) {
        return (value >= 0 && value <= 5);
    }, 'Please enter a value between 0 and 5');

    var enrollmentDateMessage = ""
    $.validator.addMethod("enrollmentDateValid", function(value, element, params) {
        var currentDate = new Date();
        currentDate.setMonth(currentDate.getMonth() + 1);
        currentDate.setDate(1);
        currentDate.setHours(0);
        currentDate.setMinutes(0);
        currentDate.setSeconds(0);
        currentDate.setMilliseconds(0);

        var upperBound = new Date(currentDate.getFullYear() + 1, currentDate.getMonth());

        selectedMonth = $("#project_bookbub_submissions_attributes_0_enrollment_date_2i").val()
        var selectedDate = new Date(value, selectedMonth - 1,1 );

        return currentDate <= selectedDate && selectedDate <= upperBound;
    }, 'Your enrollment date must be no more than one year in the future and cannot be in the past.');

    $('#bookbub_submission').submit(function(){
        if(bookbub_validator.valid()) {

            // Check these values
            var past_six = ($('input[name=bookbub_past_6_months]:checked').val() == 'yes');
            var past_thirty = ($('input[name=bookbub_feature_past_30_days]:checked').val() == 'yes');
            var num_reviews = $('#project_bookbub_submissions_attributes_0_num_reviews').val();
            var avg_stars = $('#project_bookbub_submissions_attributes_0_num_stars').val();
            var num_pages = $('#project_bookbub_submissions_attributes_0_num_pages').val();

            // If they pass all rules, we can submit.
            if(! past_six && ! past_thirty && num_reviews >= 20 && avg_stars >= 4 && num_pages >= 150) {
                return true;
            } else {
                $('#bookbub_submit_button').attr('disabled');
                $('#bookbub_submission_button_box').html("We're sorry, but your book does not meet the minimum requirements and does not qualify for a Bookbub submission at this time.");
                return false;
            }

        }
    });

});

