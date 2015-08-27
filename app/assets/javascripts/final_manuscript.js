// assets/javascripts/final_manuscript.js
$(function() {

    // PDF File
    $('#final_manuscript_pdf_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#final_manuscript_pdf_uploads_container'),
            before_add: function(file) {
                if (/(pdf)$/i.test(file.type)) {
                    return true;
                } else {
                    alert('File type must be .pdf');
                    return false;
                }
            }

    }
    );
    $('#final_manuscript_pdf_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });

    // Optional Doc File
    $('#final_manuscript_doc_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#final_manuscript_doc_uploads_container'),
            before_add: function(file) {
                // Same as Constants::DefaultContentTypeDocumentParams
                //if (/(application\/msword|application\/vnd\.openxmlformats-officedocument\.wordprocessingml.document|text\/plain)$/i.test(file.type) || (/(doc?x)$/i.test(file.name))) {
                    return true;
                //} else {
                //    alert('File type must be .doc or .docx');
                //    return false;
                //}
            }
        }
    );
    $('#final_manuscript_pdf_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });


});