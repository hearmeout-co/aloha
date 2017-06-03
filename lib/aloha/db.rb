require 'sinatra/activerecord'

if ENV['RACK_ENV'] == 'test'
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/test')
else
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/aloha')
end

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)