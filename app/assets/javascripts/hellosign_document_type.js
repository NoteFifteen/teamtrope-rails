/**
 * JavaScript used for the Request Image Form
 */

// An attempt at namespacing to avoid a bunch of global functions
if(! Teamtrope) {
    var Teamtrope = {};
}

Teamtrope.HelloSignDocumentType = {};
Teamtrope.HelloSignDocumentType.RequestList = function(table, objectName, dataMap) {
    this.table = table;
    this.objectName = objectName;
    this.dataMap = dataMap;
};

Teamtrope.HelloSignDocumentType.RequestList.prototype.drawRow = function (rowData) {
    var row = $("<tr />");
    this.table.append(row);

    Object.keys(this.dataMap).forEach(function(key) {
        var value = rowData[key];
        row.append($("<td> <input type=\"text\" class=\"form-control\" name=\"" + key +  "\" value=\"" + value + "\"></td>"));
    });

    row.append($("<td> <span class=\"glyphicon glyphicon-plus\" aria-hidden=\"true\" onclick=\"" + this.objectName + ".addRow(this, 0);\"></span> <span class=\"glyphicon glyphicon-minus\" aria-hidden=\"true\" onclick=\"" + this.objectName +".removeRow(this);\"></span> </td>"));
};

Teamtrope.HelloSignDocumentType.RequestList.prototype.drawTable = function (data) {
    var myObj = this;
    $.each(data, function (index, object) {
        myObj.drawRow(object);
    });
};

Teamtrope.HelloSignDocumentType.RequestList.prototype.addEmptyRow = function () {
    var rowData = {
        name: '',
        email_address: '',
        role: ''
    };

    this.drawRow(rowData);
};

Teamtrope.HelloSignDocumentType.RequestList.prototype.addRow = function (element, max) {
    var tr = jQuery(element).closest('tr');
    var clone = tr.clone();

    clone.find("input, select").val("").attr("tabindex", clone.find('input:last').attr("tabindex"));
    tr.after(clone);
};

Teamtrope.HelloSignDocumentType.RequestList.prototype.removeRow = function (element) {
    var tr = $(element).closest('tr');
    tr.remove();

    if( this.table.find('tbody tr').length == 0) {
        this.addEmptyRow();
    }
};

Teamtrope.HelloSignDocumentType.RequestList.prototype.tableToJson = function () {
    var validRows = [];

    var dataMap = this.dataMap;
    this.table.find('tbody tr').each(function () {

        var isValid = true;
        rowData = {}
        var table = this;

        Object.keys(dataMap).forEach(function(key) {
            var item = $(table).find('td [name='+key+']:input').val();
            if(item.length < 0)
                isValid = false;
            rowData[key] = item
        });

        if(isValid)
            validRows.push(rowData);


    });
    return JSON.stringify(validRows);
};

Teamtrope.HelloSignDocumentType.RequestList.prototype.initialize = function (image_list_json) {
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
    signersList = new Teamtrope.HelloSignDocumentType.RequestList( $("#signers_table"), 'signersList', { name: '', email_address: '', role: '' });
    signersList.initialize( $("#hellosign_document_type_signers").val() );

    ccsList = new Teamtrope.HelloSignDocumentType.RequestList( $("#ccs_table"), 'ccsList', { email_address: '', role: '' }  );
    ccsList.initialize( $("#hellosign_document_type_ccs").val() );

    // Populate the hidden field with JSON data.
    $("#hellosign_document_type_form").submit(function() {
        $("#hellosign_document_type_signers").val(signersList.tableToJson());
        $("#hellosign_document_type_ccs").val(ccsList.tableToJson());
    });

});

