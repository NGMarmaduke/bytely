class CreateBytes < ActiveRecord::Migration
  def change
    create_table :bytes do |t|
      t.string :full_url
      t.string :byte

      t.timestamps
    end
  end
end
