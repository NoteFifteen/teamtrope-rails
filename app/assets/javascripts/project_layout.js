// assets/javascripts/project_layout.js
$(function() {
    // PDF Layout
    $('#layout_layout_upload_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#layout_layout_upload_container'),
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
    $('#layout_layout_upload_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });
});
