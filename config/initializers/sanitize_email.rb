#
# Refer to https://github.com/pboling/sanitize_email for more info
#
SanitizeEmail::Config.configure do |config|
  config[:sanitized_to] =         Figaro.env.mail_sanitized_to
  config[:sanitized_cc] =         Figaro.env.mail_sanitized_cc
  config[:sanitized_bcc] =        Figaro.env.mail_sanitized_bcc
  # run/call whatever logic should turn sanitize_email on and off in this Proc:
  config[:activation_proc] =      Proc.new { %w(development test).include?(Rails.env) }
  config[:use_actual_email_prepended_to_subject] = false        # or false
  config[:use_actual_environment_prepended_to_subject] = true   # or false
  config[:use_actual_email_as_sanitized_user_name] = true       # or false
end
