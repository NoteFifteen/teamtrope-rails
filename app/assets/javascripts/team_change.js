/**
 * Javascript functions for useability and form validation for the Team Change form.
 */
$(document).ready(function() {

    /**
     * Populate the member list with the team members
     */
    var team_select = $('#remove_team_member_users');

    // Populate based on JSON membership list
    if(team_memberships.length > 0) {
        $.each(team_memberships, function() {
            if(this.membership_id && this.membership_id !== 'undefined') {
                team_select.append($('<option/>', {
                        value: this.membership_id,
                        text: this.member_name
                    }
                ));
            }
        });
    }

    // Show that the field is for "Other" reasons but only if it has not been filled
    // and is out of focus.
    $('#team_removal_reason_other_input').focus(function() {
        $('#project_audit_team_membership_removals_attributes_0_reason_other').prop("checked", true);
        if(this.value == 'Other') {
            this.value = '';
        }
    });
    $('#team_removal_reason_other_input').blur(function() {
        if(this.value == '') {
            this.value = 'Other';
        }
    });

    // Automatically change focus to the input box if they select other
    $("#project_audit_team_membership_removals_attributes_0_reason_other").change(function() {
        if (this.checked) {
            $('#team_removal_reason_other_input').focus();
        }
    });

    $("#remove_team_member").validate({
        errorElement: "div",
        errorPlacement: function(error, element) {
            error.appendTo("div#remove_team_member_errors");
        },
        rules: {
            'project[audit_team_membership_removals_attributes][0][member_id]': {
                required: true
            },
            'project[audit_team_membership_removals_attributes][0][reason]': {
                required: true
            },
            'project[audit_team_membership_removals_attributes][0][notified_member]': {
                required: true
            },
            'team_removal_reason_other_input': {
                otherReasonValid: true
            }

        },
        messages: {
            'project[audit_team_membership_removals_attributes][0][member_id]': {
                required: 'You must select a member to remove.'
            },
            'project[audit_team_membership_removals_attributes][0][reason]': {
                required: 'You must select a reason for removal.'
            },
            'project[audit_team_membership_removals_attributes][0][notified_member]': {
                required: 'You must identify whether you have notified the member of their pending removal.'
            }
        }
    });

// Validator for the "Other" input box
    $.validator.addMethod("otherReasonValid", function(value) {
        var checked =  $('#project_audit_team_membership_removals_attributes_0_reason_other').is(':checked');

        if(! checked) {
            return true;
        } else {
            return (value != "Other" && value != '');
        }
    }, 'Please enter a reason when selecting "Other".');

});

