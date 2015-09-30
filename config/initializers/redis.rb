url = (ENV['REDISCLOUD_URL'] || 'redis://localhost:6379')
REDIS = Redis.connect url: url
