/**
 * JavaScript used for the Request Image Form
 */

// An attempt at namespacing to avoid a bunch of global functions
var Teamtrope = Teamtrope || {};

Teamtrope.Cover = {};
Teamtrope.Cover.ImageRequestList = function(table) {
    this.table = table;
};

Teamtrope.Cover.ImageRequestList.prototype.drawRow = function (rowData) {
    var row = $("<tr />");
    this.table.append(row);
    row.append($("<td> <input type=\"text\" class=\"form-control\" name=\"subject\" value=\"" + rowData.subject + "\"></td>"));
    row.append($("<td> <input type=\"text\" class=\"form-control\" name=\"link\" value=\"" + rowData.link + "\" placeholder=\"http://\"></td>"));
    row.append($("<td> <span class=\"glyphicon glyphicon-plus\" aria-hidden=\"true\" onclick=\"imageRequestList.addRow(this, 0);\"></span> <span class=\"glyphicon glyphicon-minus\" aria-hidden=\"true\" onclick=\"imageRequestList.removeRow(this);\"></span> </td>"));
};

Teamtrope.Cover.ImageRequestList.prototype.drawTable = function (data) {
    var myObj = this;
    $.each(data, function (index, object) {
        myObj.drawRow(object);
    });
};

Teamtrope.Cover.ImageRequestList.prototype.addEmptyRow = function () {
    var rowData = {
        subject: '',
        link: ''
    };

    this.drawRow(rowData);
};

Teamtrope.Cover.ImageRequestList.prototype.addRow = function (element, max) {
    var tr = jQuery(element).closest('tr');
    var clone = tr.clone();

    clone.find("input, select").val("").attr("tabindex", clone.find('input:last').attr("tabindex"));
    tr.after(clone);
};

Teamtrope.Cover.ImageRequestList.prototype.removeRow = function (element) {
    var tr = $(element).closest('tr');
    tr.remove();

    if( this.table.find('tbody tr').length == 0) {
        this.addEmptyRow();
    }
};

Teamtrope.Cover.ImageRequestList.prototype.tableToJson = function () {
    var validRows = [];

    this.table.find('tbody tr').each(function () {
        var subject = $(this).find('td [name=subject]:input').val();
        var link = $(this).find('td [name=link]:input').val();

        if( subject.length > 0 && link.length > 0) {

            validRows.push( {
                subject: subject,
                link: link
            } );
        }
    });

    return JSON.stringify(validRows);
};

Teamtrope.Cover.ImageRequestList.prototype.initialize = function (image_list_json) {
    if(image_list_json != null && image_list_json.length > 0) {
        var image_list = jQuery.parseJSON(image_list_json);
        if(image_list.length > 0) {
            this.drawTable(image_list);
        } else {
            this.addEmptyRow();
        }
    } else {
        this.addEmptyRow();
    }
};


$(document).ready(function() {

    // Populate the image request list from a hidden field containing the JSON data
    imageRequestList = new Teamtrope.Cover.ImageRequestList( $("#image_request_list_table") );
    imageRequestList.initialize( $("#project_cover_concept_attributes_image_request_list").val() );

    // Populate the hidden field with JSON data.
    $("#request_images_form").submit(function() {
        $("#project_cover_concept_attributes_image_request_list").val(imageRequestList.tableToJson());
    });

});

