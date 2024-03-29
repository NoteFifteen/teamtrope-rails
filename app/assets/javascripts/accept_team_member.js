/**
 * These are the functions used for the Accept Team Member form
 * used in a namespaced format.
 */

if(! Teamtrope) {
    var Teamtrope = {};
}

Teamtrope.BuildTeam = {};
Teamtrope.BuildTeam.AcceptMember = function(role_select, member_select) {
    this.role_select = role_select;
    this.member_select = member_select;
    this.member_roles = [];
    this.team_members = {};
    this.role_definitions = {};
};

Teamtrope.BuildTeam.AcceptMember.prototype.addTeamMembers = function (team_members) {
    if ($.isArray(team_members) && team_members.length > 0) {
        var list = this.team_members;

        $.each(team_members, function() {
            if(this.role && this.role !== 'undefined') {

                if(! $.isArray(list[this.role])) {
                    list[this.role] = [];
                }

                list[this.role].push({
                    id: this.id,
                    name: this.name,
                    role: this.role,
                    percentage: this.percentage
                });
            }
        });
    }
};

Teamtrope.BuildTeam.AcceptMember.prototype.getTeamMembersInRole = function (role) {
    return this.team_members[role];
};

Teamtrope.BuildTeam.AcceptMember.prototype.getTeamMembers = function () {
    var list = this.team_members;
    return ($.isPlainObject(list)) ? list : {};
};

/**
 * Produce the lists of available members for a role, filtering out members
 * that should not be able to participate.
 */
Teamtrope.BuildTeam.AcceptMember.prototype.addMembersToRole = function (role, members) {
    var authors = this.getTeamMembersInRole('author');
    var editors = this.getTeamMembersInRole('editor');
    var proofreaders = this.getTeamMembersInRole('proofreader');

    var existing_authors = [];
    $.merge(existing_authors, this.getIdsFromMemberList(authors));

    // Proof Readers cannot be the current Author or Editor and we want to exclude any existing Proof Readers.
    var excluded_from_proofreaders = [];
    $.merge(excluded_from_proofreaders, this.getIdsFromMemberList(authors));
    $.merge(excluded_from_proofreaders, this.getIdsFromMemberList(editors));
    $.merge(excluded_from_proofreaders, this.getIdsFromMemberList(proofreaders));

    // Editors cannot be the current Proof Reader and we want to exclude any existing Editors.
    var excluded_from_editors = [];
    $.merge(excluded_from_editors, this.getIdsFromMemberList(proofreaders));
    $.merge(excluded_from_editors, this.getIdsFromMemberList(editors));

    if ($.isArray(members) && members.length > 0) {
        this.member_roles[role] = [];

        for(i = 0; i < members.length; i++) {

            if(role === 'authors') {
                if($.inArray(members[i].id, existing_authors) !== -1) {
                    continue;
                }
            }

            if(role === 'proofreaders') {
                if($.inArray(members[i].id, excluded_from_proofreaders) !== -1) {
                    continue;
                }
            }

            if(role === 'editors') {
                if($.inArray(members[i].id, excluded_from_editors) !== -1) {
                    continue;
                }
            }

            this.member_roles[role].push(members[i]);
        }
    }

    return this.member_roles;
};

Teamtrope.BuildTeam.AcceptMember.prototype.getIdsFromMemberList = function (members) {
    var ids = [];
    if ($.isArray(members) && members.length > 0) {
        for (i = 0; i < members.length; i++) {
            ids.push(members[i].id);
        }
    }

    return ids;
};

Teamtrope.BuildTeam.AcceptMember.prototype.addRoleDefinition = function (role_name, suggested_percentage) {
    this.role_definitions[role_name] = { name: role_name, suggested_percentage: suggested_percentage }
};

Teamtrope.BuildTeam.AcceptMember.prototype.getSuggestedPercentageForRole = function (role_name) {
    return (this.role_definitions[role_name]) ? this.role_definitions[role_name].suggested_percentage : 0;
};

Teamtrope.BuildTeam.AcceptMember.prototype.getMembersForRole = function (role) {
    var list = this.member_roles[role];
    if($.isArray(list)) {
        // Alphabetize the list
        list.sort(function (a, b) {
            return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
        });
    } else {
        list = [];
    }

    return list;
};

Teamtrope.BuildTeam.AcceptMember.prototype.updateMemberSelect = function () {
    // Normalize the name & pluralize in a very simple fashion
    var selected_role = this.normalizeName($(this.role_select).find('option:selected').text()) + "s";
    var member_list = this.getMembersForRole(selected_role);

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

Teamtrope.BuildTeam.AcceptMember.prototype.normalizeName = function (name) {
    return name.replace(/ /g,"_").toLowerCase();
};

/**
 * Code for handling the Percentage allocation updates
 */
Teamtrope.BuildTeam.AcceptMember.PercentageCalculator = function(percentage_input, percentage_indicator, table_indicator) {
    this.team_members = {};
    this.percentage_input = percentage_input;
    this.percentage_indicator = percentage_indicator;
    this.table_allocated_total_indicator = table_indicator;

    this.total_percentage = 0;
};

Teamtrope.BuildTeam.AcceptMember.PercentageCalculator.prototype.addTeamMembers = function (team_members) {
    if($.isPlainObject(team_members)) {
      this.team_members = team_members;
    }

    // Update the totals and trigger a progress bar update
    this.calculateTotal(true);
};

Teamtrope.BuildTeam.AcceptMember.PercentageCalculator.prototype.calculateTotal = function (update_indicator) {
    update_indicator = update_indicator || false;

    var total_percentage = 0;

    // Total the percentages from the team members
    if($.isPlainObject(this.team_members)) {
        $.each(this.team_members, function (role_type, role_members) {
            $.each(role_members, function (member) {
                if (this.percentage && (!isNaN(parseFloat(this.percentage)))) {
                    total_percentage += this.percentage;
                }
            });
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

    this.table_allocated_total_indicator.html(this.total_percentage.toFixed(1) + '%');

    this.percentage_indicator.toggleClass('progress-bar-success progress-bar-warning progress-bar-danger', false);

    if(this.total_percentage > 70) {
        this.percentage_indicator.css('width', '100%');
        this.percentage_indicator.find('span').text('Over 70% Allocated!');
        this.percentage_indicator.toggleClass('progress-bar-danger');
    } else if(this.total_percentage > 60) {
        this.percentage_indicator.css('width', (this.total_percentage + 30) + '%');
        this.percentage_indicator.find('span').text(this.total_percentage.toFixed(1) + '% Allocated');

        if(this.total_percentage === 70) {
            this.percentage_indicator.toggleClass('progress-bar-success');
        } else {
            this.percentage_indicator.toggleClass('progress-bar-warning');
        }
    } else {
        this.percentage_indicator.css('width', (this.total_percentage + 30) + '%');
        this.percentage_indicator.find('span').text(this.total_percentage.toFixed(1) + '% Allocated');
    }
};

// Initial setup for the Accept Team Member form
$(document).ready(function() {

    // Bind the update to the list of team members based on the role change
    $('#accept_team_member_roles').change(function() {
        Teamtrope.acceptForm.updateMemberSelect();

        var role_name = $('#accept_team_member_roles').find('option:selected').text();
        var percentageInput = $('#accept_team_member_percentage_input');
        percentageInput.val(Teamtrope.acceptForm.getSuggestedPercentageForRole(role_name));
        Teamtrope.percentageCalculator.calculateTotal(true);
    });

    // Bind the update of the percentage input to the calculation total and progress bar update
    $('#accept_team_member_percentage_input').bind('propertychange change click keyup input paste', function() {
        Teamtrope.percentageCalculator.calculateTotal(true);
    });

});
