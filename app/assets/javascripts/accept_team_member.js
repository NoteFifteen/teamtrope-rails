/**
 * These are the functions used for the Accept Team Member form
 * used in a namespaced format.
 */

var Teamtrope = Teamtrope || {};

Teamtrope.BuildTeam = {};
Teamtrope.BuildTeam.AcceptMember = function(role_select, member_select) {
    this.role_select = role_select;
    this.member_select = member_select;
    this.member_roles = [];
    this.team_members = {};
};

Teamtrope.BuildTeam.AcceptMember.prototype.addTeamMembers = function (team_members) {
    if ($.isArray(team_members) && team_members.length > 0) {
        var list = this.team_members;

        $.each(team_members, function() {
            if(this.role && this.role !== 'undefined') {
                list[this.role] = {
                    id: this.id,
                    name: this.name,
                    role: this.role,
                    percentage: this.percentage
                }
            }
        });
    }
};

Teamtrope.BuildTeam.AcceptMember.prototype.getTeamMember = function (role) {
    return this.team_members[role];
};

Teamtrope.BuildTeam.AcceptMember.prototype.getTeamMembers = function () {
    var list = this.team_members;
    return ($.isPlainObject(list)) ? list : {};
};

Teamtrope.BuildTeam.AcceptMember.prototype.addMembersToRole = function (role, members) {
    var author = this.getTeamMember('author');
    var editor = this.getTeamMember('editor');
    var proof_reader = this.getTeamMember('proof_reader');

    if ($.isArray(members) && members.length > 0) {
        this.member_roles[role] = [];

        for(i = 0; i < members.length; i++) {

            // Proof Readers cannot be the current Author or Editor
            if(role === 'proof_readers') {
                if(typeof author !== "undefined" && members[i].id === author.id) {
                    continue;
                }
                if(typeof editor !== "undefined" && members[i].id === editor.id) {
                    continue;
                }
            }

            // Editors cannot be the current Proof Reader
            if(role === 'editors') {
                if(typeof proof_reader !== "undefined" && members[i].id === proof_reader.id) {
                    continue;
                }
            }

            this.member_roles[role].push(members[i]);
        }
    }
};

Teamtrope.BuildTeam.AcceptMember.prototype.getMembersForRole = function (role) {
    var list = this.member_roles[role];
    return ($.isArray(list)) ? list : [];
};

Teamtrope.BuildTeam.AcceptMember.prototype.updateMemberSelect = function () {
    var selected_role = $(this.role_select).find('option:selected').text();
    var member_list = [];

    switch(selected_role) {
        case 'Book Manager':
            member_list = this.getMembersForRole('book_managers');
            break;
        case 'Cover Designer':
            member_list = this.getMembersForRole('cover_designers');
            break;
        case 'Editor':
            member_list = this.getMembersForRole('editors');
            break;
        case 'Proof Reader':
            member_list = this.getMembersForRole('proof_readers');
            break;
        case 'Project Manager':
            member_list = this.getMembersForRole('project_managers');
            break;
    }

    // Necessary for scope inside the anonymous function that appends
    // options to the list
    var memberSelect = this.member_select;

    // Empty the list
    memberSelect.find('option')
        .remove()
        .end();

    // Add new list
    if(member_list.length > 0) {

        // Prepend an empty option first so the placeholder will show
        memberSelect.append($('<option/>'));

        $.each(member_list, function() {
            memberSelect.append($('<option/>', {
                value: this.id,
                text: this.name
            }));
        });
        memberSelect.attr('data-placeholder', 'Select a Member');
    } else {
        memberSelect.attr('data-placeholder', 'Select a Role first');
    }

    // Trigger an update for Chosen
    memberSelect.trigger("chosen:updated");
};

/**
 * Code for handling the Percentage allocation updates
 */
Teamtrope.BuildTeam.AcceptMember.PercentageCalculator = function(percentage_input, percentage_indicator) {
    this.team_members = {};
    this.percentage_input = percentage_input;
    this.percentage_indicator = percentage_indicator;

    this.total_percentage = 0;
};

Teamtrope.BuildTeam.AcceptMember.PercentageCalculator.prototype.addTeamMembers = function (team_members) {
    if($.isPlainObject(team_members)) {
      this.team_members = team_members;
    }

    // Update the totals and trigger a progress bar update
    this.calculateTotal(true, true);
};

Teamtrope.BuildTeam.AcceptMember.PercentageCalculator.prototype.calculateTotal = function (update_indicator, include_booktrope) {
    update_indicator = update_indicator || false;
    include_booktrope = include_booktrope || false;

    if(include_booktrope) {
        var total_percentage = 30; // Booktrope gets 30%
    } else {
        var total_percentage = 0;
    }

    // Total the percentages from the team members
    if($.isPlainObject(this.team_members)) {
        $.each(this.team_members, function (key, val) {
            //alert(val.name);
            if (val.percentage && (!isNaN(parseFloat(val.percentage)))) {
                total_percentage += val.percentage;
            }
        });
    }

    // Get the input value if it's there
    var input_value = this.percentage_input.val();
    if(!isNaN(parseFloat(input_value)) && parseFloat(input_value) > 0) {
        total_percentage += parseFloat(input_value);
    }

    this.total_percentage = total_percentage;

    // Update the indicator
    if(update_indicator) {
        this.updateIndicator();
    }

    return total_percentage;
};

Teamtrope.BuildTeam.AcceptMember.PercentageCalculator.prototype.updateIndicator = function () {

    this.percentage_indicator.toggleClass('progress-bar-success progress-bar-warning progress-bar-danger', false);

    if(this.total_percentage > 100) {
        this.percentage_indicator.css('width', '100%');
        this.percentage_indicator.find('span').text('Over 100% Allocated!');
        this.percentage_indicator.toggleClass('progress-bar-danger');
    } else if(this.total_percentage > 90) {
        this.percentage_indicator.css('width', this.total_percentage + '%');
        this.percentage_indicator.find('span').text(this.total_percentage + '% Allocated');

        if(this.total_percentage === 100) {
            this.percentage_indicator.toggleClass('progress-bar-success');
        } else {
            this.percentage_indicator.toggleClass('progress-bar-warning');
        }
    } else {
        this.percentage_indicator.css('width', this.total_percentage + '%');
        this.percentage_indicator.find('span').text(this.total_percentage + '% Allocated');
    }
};

// Initial setup for the Accept Team Member form
$(document).ready(function() {
    acceptForm = acceptForm || new Teamtrope.BuildTeam.AcceptMember(
                                    $('#accept_team_member_roles'),
                                    $('#accept_team_member_users')
                                );

    percentageCalculator = percentageCalculator || new Teamtrope.BuildTeam.AcceptMember.PercentageCalculator(
        $('#accept_team_member_percentage_input'),
        $('#accept_team_member_percentage_indicator')
    );

    // Update the members in the select box
    acceptForm.updateMemberSelect();

    // Bind the update to the list of team members based on the role change
    $('#accept_team_member_roles').change(function() {
        acceptForm.updateMemberSelect();
    });

    // Bind the update of the percentage input to the calculation total and progress bar update
    $('#accept_team_member_percentage_input').bind('propertychange change click keyup input paste', event, function() {
        percentageCalculator.calculateTotal(true, true);
    });

});
