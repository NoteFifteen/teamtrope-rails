$(function() {
    // final_cover_screenshot
    $('#cover_template_final_cover_screenshot_s3_uploader').S3Uploader(
        {
            remove_completed_progress_bar: false,
            progress_bar_target: $('#cover_template_final_cover_screenshot_uploads_container'),
            before_add: function(file) {
                if (/\.(jpe?g|png)$/i.test(file.name)) {
                    return true;
                } else {
                    alert('File type must be .jpg or .png');
                    return false;
                }
            }
    }
    );
    $('#cover_template_final_cover_screenshot_s3_uploader').bind('s3_upload_failed', function(e, content) {
        return alert(content.filename + ' failed to upload');
    });
});
