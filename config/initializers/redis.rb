url = (ENV['REDISCLOUD_URL'] || 'redis://localhost:6379')
Resque.redis = url
