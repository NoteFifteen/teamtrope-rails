require 'hello_sign'

HelloSign.configure do | config |
	config.api_key = Figaro.env.hellosign_api_key
end