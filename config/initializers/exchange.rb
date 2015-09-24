# Initializer for exchange currency converter (https://github.com/beatrichartz/exchange)
Exchange.configuration = Exchange::Configuration.new do |c|
  c.api = {
      :subclass => :open_exchange_rates,
      :app_id => Figaro.env.open_exchange_api_key,
      :retries => 5
  }

  # It would be nice to use Redis, but Heroku Redis requires authentication,
  # and the driver included with the exchange gem does not.
  c.cache = {
      :subclass => :rails
  }
end