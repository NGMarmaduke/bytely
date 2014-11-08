class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.string :referrer_domain
      t.string :referrer
      t.string :ip
      t.string :device
      t.integer :byte_id

      t.timestamps
    end
  end
end
