# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
worker_processes (ENV['WEB_CONCURRENCY'] || 1).to_i
timeout 30