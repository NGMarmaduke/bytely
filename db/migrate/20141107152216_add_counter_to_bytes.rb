class AddCounterToBytes < ActiveRecord::Migration
  def change
    add_column :bytes, :click_count, :integer, :default => 0
  end
end
