web: env WEB_ONLY=1 bundle exec unicorn -p $PORT -c config/unicorn.rb -E $RACK_ENV
worker: env BOT_ONLY=1 bundle exec unicorn -p $PORT -E $RACK_ENV