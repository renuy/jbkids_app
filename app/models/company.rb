class Company < ActiveRecord::Base
  has_and_belongs_to_many :branches
  has_and_belongs_to_many :users
  has_many :passcode
  
end
