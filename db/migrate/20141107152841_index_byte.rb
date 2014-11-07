class IndexByte < ActiveRecord::Migration
  def change
    add_index :bytes, :byte
  end
end
