class AddLocationToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :location, :string
    add_column :clicks, :city, :string
    add_column :clicks, :country, :string
    add_column :clicks, :country_code, :string
  end
end
