module PaperclipS3UploadProcessing
  # teamtrope-rails-testing vs teamtrope-com
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/teamtrope\-#{!Rails.env.production? ? "rails\-testing" : 'com'}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  def unescape_url(escaped_url)
    CGI.unescape(escaped_url) rescue nil
  end

  # Final upload processing step
  def transfer_and_cleanup_with_block
    direct_upload_url_data = self.get_direct_upload_url

    return if direct_upload_url_data.nil?

    s3 = AWS::S3.new

    type = self.get_uploaded_type

    # paperclip_file_path = "documents/uploads/#{id}/original/#{direct_upload_url_data[:filename]}"
    paperclip_file_path = eval("self.#{type}.path")
    s3.buckets[S3DirectUpload.config.bucket].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])

    yield (type)

    s3.buckets[S3DirectUpload.config.bucket].objects[direct_upload_url_data[:path]].delete
  end

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes_with_block
    direct_upload_url_data = self.get_direct_upload_url

    return if direct_upload_url_data.nil?

    tries ||= 5

    s3 = AWS::S3.new
    direct_upload_head = s3.buckets[S3DirectUpload.config.bucket].objects[direct_upload_url_data[:path]].head

    type = self.get_uploaded_type

    yield(type, direct_upload_url_data, direct_upload_head)

    type
  rescue AWS::S3::Errors::NoSuchKey => e
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
    end
  end

end