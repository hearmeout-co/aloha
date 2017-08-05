if ENV['RACK_ENV'] == 'test'
  ENV['DATABASE_URL'] ||= 'postgres://localhost/test'
else
  ENV['DATABASE_URL'] ||= 'postgres://localhost/aloha'
end

OTR::ActiveRecord.configure_from_file! "config/database.yml"

use OTR::ActiveRecord::ConnectionManagement
