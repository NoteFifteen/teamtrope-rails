S3DirectUpload.config do |c|
  c.access_key_id = Figaro.env.aws_access_key_id
  c.secret_access_key = Figaro.env.aws_secret_access_key
  c.bucket = Figaro.env.s3_bucket_name
  c.region = 's3'
  c.url = "https://#{c.bucket}.s3.amazonaws.com/"
end