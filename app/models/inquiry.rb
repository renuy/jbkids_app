class Inquiry < ActiveRecord::Base
  validates :email, :presence => true
  validates :name, :presence => true
  validates :corporate_name, :presence => true
  validates :phone, :presence => true
  validates :shop_choice, :presence => true
  validates :access_points, :presence => true
  validates :pay_options, :presence => true

end
