# Sets the hostname in URL links
Rails.application.config.action_mailer.default_url_options = { host: Figaro.env.mail_hostname }

Rails.application.config.action_mailer.default_options = {
    from: "no-reply@teamtrope.com"
}
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
    address:         Figaro.env.mail_smtp_server_address,
    port:            Figaro.env.mail_smtp_server_port,
    domain:          Figaro.env.mail_domain,
    user_name:       Figaro.env.mail_user_name,
    password:        Figaro.env.mail_password,
    authentication:  :plain
}
