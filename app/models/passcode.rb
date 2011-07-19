class Passcode < ActiveRecord::Base
  establish_connection Rails.configuration.database_configuration["memp_db"] 
  belongs_to :companies
end
