/** imported contract Form **/
$(function() {

    // PDF File
    $('#imported_contract_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#imported_contract_uploads_container'),
            before_add: function (file) {
                return true;
            }

        }
    );
    $('#imported_contract_s3_uploader').bind('s3_upload_failed', function (e, content) {
        return alert(content.filename + ' failed to upload');
    });

});
