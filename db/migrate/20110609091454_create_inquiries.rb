class CreateInquiries < ActiveRecord::Migration
  def self.up
    create_table :inquiries do |t|
      t.string :email
      t.string :name
      t.string :corporate_name
      t.string :phone
      t.string :city
      t.string :shop_choice
      t.string :access_points
      t.string :pay_options
      t.timestamps
    end
  end

  def self.down
    drop_table :inquiries
  end
end
