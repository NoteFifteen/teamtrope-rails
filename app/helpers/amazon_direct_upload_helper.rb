module AmazonDirectUploadHelper
  def self.append_prefix(prefix, field_name)
    unless prefix.nil? || prefix.empty?
      pieces = [prefix, field_name]
      with = prefix.end_with?('_')? "" : "_"
      pieces.join(with)
    else
      field_name
    end
  end
end
