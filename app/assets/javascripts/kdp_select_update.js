/**
 * These are the functions used for the KDP Select Update form
 * used in a namespaced format.
 */

var Teamtrope = Teamtrope || {};

Teamtrope.KdpSelectUpdate = function(){};

// Function to handle Submit
Teamtrope.KdpSelectUpdate.prototype.handleSubmit = function () {

    // Get the current selection
    var selected_option = $('input[name=project\\[kdp_select_enrollment_attributes\\]\\[update_type\\]]:checked').val();

    // Grab values based on selection
    switch(selected_option) {
        case 'countdown_deal':
            var update_data = this.getCountdownDealValues();
            break;
        case 'free_book_promo':
            var update_data = this.getFreeBookPromoValues();
            break;
        case 'remove_from_kdp':
            var update_data = ''; // Record something here?
            break;
        default:
            return false;
    }

    // Set the JSON encoded data in the hidden field
    $('#project_kdp_select_enrollment_attributes_update_data').val(JSON.stringify(update_data));

    // FYI: Our return value determines whether or not the form will post.
    return true;
};

// Function to validate & grab values for Countdown Deal
Teamtrope.KdpSelectUpdate.prototype.getCountdownDealValues = function () {
    return {
        start_date: this.getDateFromInputs('countdown_start_date'),
        start_time: this.getTimeFromInputs('countdown_start_time'),
        number_of_days: this.getSelectedValue('countdown_num_days'),
        number_of_price_increments: this.getSelectedValue('countdown_num_price_increments'),
        starting_promo_price: this.getInputValue('countdown_start_price')
    };
};

// Function to validate & grab values for Free Book Promo
Teamtrope.KdpSelectUpdate.prototype.getFreeBookPromoValues = function () {

    var num_date_ranges = this.getSelectedValue('free_book_num_date_ranges');
    var date_ranges = [];

    // free_book_start_date_1[year]
    var start_prefix = 'free_book_start_date_';
    var end_prefix   = 'free_book_end_date_';

    for (var x = 1; x <= num_date_ranges; x++) {
        date_ranges.push({
            start_date: this.getDateFromInputs(start_prefix + x),
            end_date: this.getDateFromInputs(end_prefix + x)
        });
    }

    return {
        number_date_ranges: num_date_ranges,
        date_ranges: date_ranges
    };
};

// Return a date string from a triplet of select elements of year/month/day
Teamtrope.KdpSelectUpdate.prototype.getDateFromInputs = function (base_name) {
    var year  = this.getSelectedValue(base_name + '\\[year\\]');
    var month = this.getSelectedValue(base_name + '\\[month\\]');
    var day   = this.getSelectedValue(base_name + '\\[day\\]');
    return (year + "/" + month + "/" + day);
};

// Return a time string from a select elements of hour:day in hh:mm:ss format
Teamtrope.KdpSelectUpdate.prototype.getTimeFromInputs = function (base_name) {
    var hour   = this.getSelectedValue(base_name + '\\[hour\\]');
    var minute = this.getSelectedValue(base_name + '\\[minute\\]');
    return (hour + ":" + minute + ":00");
};

// Get the value of the selected option for a given select name
Teamtrope.KdpSelectUpdate.prototype.getSelectedValue = function (name) {
    var option = $('[name=' + name +']').find('option:selected');
    if(typeof option !== 'undefined') {
        return option.val();
    }

    return '';
};

// Get the value of the selected text input
Teamtrope.KdpSelectUpdate.prototype.getInputValue = function (name) {
    var element = $('[name=' + name +']');
    if(typeof element !== 'undefined') {
        return element.val();
    }

    return '';
};

// Function to handle Removing KDP Select -- Not sure how to handle this


/**
 * Validator Bindings & Rules
 *
 */
$(document).ready(function(){
    // Set up the validator, we'll use it to check individual rules inside
    // custom buttons
    var kdp_validator = $('#kdp_update').validate({
        errorElement: 'span',
        errorClass: 'validationError',
        errorPlacement: function(error, element) {
            // Put the error to the right
            if(element.attr('type') === 'radio') {
                var list = $(element).closest('ul');
                error.insertBefore(list);
            } else {
                error.insertBefore(element);
            }
        },
        rules: {
            'project[kdp_select_enrollment_attributes][update_type]': {
                required: true
            },
            'countdown_start_price': {
                required: {
                    depends: function(element) {
                        var selected_option = $('input[name=project\\[kdp_select_enrollment_attributes\\]\\[update_type\\]]:checked').val();
                        return (selected_option === 'countdown_deal');
                    }
                }
            }
        },
        messages: {
            'project[kdp_select_enrollment_attributes][update_type]': {
                required: 'Please select an option.'
            },
            'countdown_start_price': {
                required: 'A starting price is necessary for this promotion'
            }
        }
    });

    // First Page - Validate, then advance based on selection
    $('#kdp_update_option_button').click(function() {
        // Validate that we've selected something
        if(kdp_validator.element('[name=project\\[kdp_select_enrollment_attributes\\]\\[update_type\\]]')) {

            // Get the selection
            var selected_option = $('input[name=project\\[kdp_select_enrollment_attributes\\]\\[update_type\\]]:checked').val();

            switch(selected_option) {
                case 'countdown_deal':
                    var new_tab = $('#kdp_update_countdown_deal');
                    break;
                case 'free_book_promo':
                    var new_tab = $('#kdp_update_free_book_promo');
                    break;
                case 'remove_from_kdp':
                    var new_tab = $('#kdp_remove_from_kdp');
                    break;
            }

            if(new_tab) {
                $('#kdp_update_first_page').hide();
                new_tab.show();
            }
        }
    });

    // Back buttons
    $('#kdp_update_countdown_back_button').click(function() {
        $('#kdp_update_countdown_deal').hide();
        $('#kdp_update_first_page').show();
    });
    $('#kdp_update_free_book_back_button').click(function() {
        $('#kdp_update_free_book_promo').hide();
        $('#kdp_update_first_page').show();
    });
    $('#kdp_remove_from_kdp_back_button').click(function() {
        $('#kdp_remove_from_kdp').hide();
        $('#kdp_update_first_page').show();
    });

    // Free Book Promo - Use the range button to show/hide the table rows
    // FYI: The values are still there, they just aren't shown.
    $('#free_book_num_date_ranges').change(function(){
        var num_date = $(this).find('option:selected').text();
        var max_dates = $(this).find('option:last').text();

        for(var i = 1; i <= max_dates; i++) {
            var element_name = "free_book_date_range_" + i;
            if(i <= num_date) {
                $("#" + element_name).show();
            } else {
                $("#" + element_name).hide();
            }
        }
    });

    // Bind our own submission handler which will bundle up the selections
    // and JSON encode them in the hidden update_data field before posting.
    $('#kdp_update').submit(function() {
        if(kdp_validator.valid()) {
            var kdp_select_handler = new Teamtrope.KdpSelectUpdate();
            return kdp_select_handler.handleSubmit();
        }
    });

});