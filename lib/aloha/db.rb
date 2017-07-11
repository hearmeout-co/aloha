if ENV['RACK_ENV'] == 'test'
  ENV['DATABASE_URL'] ||= 'postgres://localhost/test'
else
  ENV['DATABASE_URL'] ||= 'postgres://localhost/aloha'
end

OTR::ActiveRecord.configure_from_url! ENV['DATABASE_URL']

use OTR::ActiveRecord::ConnectionManagement
