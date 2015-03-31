# Options detailed here: http://www.rubydoc.info/gems/paperclip/Paperclip/Storage/S3#s3_protocol-instance_method
# Values should be stored in application.yml or your ENV
Paperclip::Attachment.default_options.merge!(
    storage: :s3,
    s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    # Default to public_read, but should modify per attachment & use download method as documented in
    # https://github.com/thoughtbot/paperclip/wiki/Restricting-Access-to-Objects-Stored-on-Amazon-S3
    s3_permissions: :public_read,
    s3_protocol: 'https',

    # Specify Domain Style, else S3 shows a redirect page
    url: ":s3_domain_url",

    # PATH in S3 Bucket - If undefined, a rather long path is used including current install path.
    # This format matches what's in "public/" locally.
    path: ':class/:attachment/:id_partition/:style/:filename'
)