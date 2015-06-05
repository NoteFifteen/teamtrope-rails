/**
 * JavaScript used for the Layout Approval Form
 */

// An attempt at namespacing to avoid a bunch of global functions
if(! Teamtrope) {
    var Teamtrope = {};
}

Teamtrope.Layout = {};
Teamtrope.Layout.IssueList = function(table) {
    this.table = table;
};

Teamtrope.Layout.IssueList.prototype.drawRow = function (rowData) {
    var row = $("<tr />");
    this.table.append(row);
    row.append($("<td class=\"issue_list_number\"> <input type=\"text\" pattern=\"[0-9]*\" class=\"form-control\" name=\"page\" value=\"" + rowData.page + "\"></td>"));
    row.append($("<td class=\"issue_list_text\"> <input type=\"text\" class=\"form-control\" name=\"problem\" value=\"" + rowData.problem + "\"></td>"));
    row.append($("<td class=\"issue_list_text\"> <input type=\"text\" class=\"form-control\" name=\"fix\" value=\"" + rowData.fix + "\"></td>"));
    row.append($("<td> <span class=\"glyphicon glyphicon-plus\" aria-hidden=\"true\" onclick=\"issueList.addRow(this, 0);\"></span> <span class=\"glyphicon glyphicon-minus\" aria-hidden=\"true\" onclick=\"issueList.removeRow(this);\"></span> </td>"));
};

Teamtrope.Layout.IssueList.prototype.drawTable = function (data) {
    var myObj = this;
    $.each(data, function (index, object) {
        myObj.drawRow(object);
    });
};

Teamtrope.Layout.IssueList.prototype.addEmptyRow = function () {
    var rowData = {
        page: '',
        problem: '',
        fix: ''
    };

    this.drawRow(rowData);
};

Teamtrope.Layout.IssueList.prototype.addRow = function (element, max) {
    var tr = jQuery(element).closest('tr');
    var clone = tr.clone();

    clone.find("input, select").val("").attr("tabindex", clone.find('input:last').attr("tabindex"));
    tr.after(clone);
};

Teamtrope.Layout.IssueList.prototype.removeRow = function (element) {
    var tr = $(element).closest('tr');
    tr.remove();

    if( this.table.find('tbody tr').length == 0) {
        this.addEmptyRow();
    }
};

Teamtrope.Layout.IssueList.prototype.tableToJson = function () {
    var validRows = [];

    this.table.find('tbody tr').each(function () {
        var page = $(this).find('td [name=page]:input').val();
        var problem = $(this).find('td [name=problem]:input').val();
        var fix = $(this).find('td [name=fix]:input').val();

        if( page.length > 0 && problem.length > 0) {

            validRows.push( {
                page: page,
                problem: problem,
                fix: fix
            } );
        }
    });

    return JSON.stringify(validRows);
};

Teamtrope.Layout.IssueList.prototype.initialize = function (issue_list_json) {
    if(issue_list_json != null && issue_list_json.length > 0) {
        var issue_list = jQuery.parseJSON(issue_list_json);
        if(issue_list.length > 0) {
            this.drawTable(issue_list);
        } else {
            this.addEmptyRow();
        }
    } else {
        this.addEmptyRow();
    }
};


// Hide the issue-list if the option for approval with changes
// is not the selected option and register an on-change event
// to reveal and hide the inputs based on selection.
$(document).ready(function() {
    var field = $("input[name=project\\[layout_attributes\\]\\[layout_approved\\]]:radio");
    var field_value = $("input[name=project\\[layout_attributes\\]\\[layout_approved\\]]:checked");

    if (! field.is(':checked') || field_value.val() == 'approved') {
        $('#approval_issue_list').hide();
    }

    $(field).change(function() {
        if (field.is(':checked')) {
            field_value = $("input[name=project\\[layout_attributes\\]\\[layout_approved\\]]:checked");

            if (field_value.val() == 'approved_revisions') {
                $('#approval_issue_list_table').slideDown();
            }
            else {
                $('#approval_issue_list_table').slideUp();
                $('#approval_issue_list input').val('');
            }
        }
    });

    // Populate the issue list from a hidden field containing the JSON data
    issueList = new Teamtrope.Layout.IssueList( $("#approval_issue_list_table") );
    issueList.initialize( $("#project_layout_attributes_layout_approval_issue_list").val() );

    // Populate the hidden field with JSON data or clear it depending on
    // approval choice during submit.
    $("#approve_layout").submit(function() {
        if (! field.is(':checked') || field_value.val() == 'approved') {
            $("#project_layout_attributes_layout_approval_issue_list").val('');
        }

        $("#project_layout_attributes_layout_approval_issue_list").val(issueList.tableToJson());
    });

});

