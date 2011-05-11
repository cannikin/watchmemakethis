class AddHeightAndWidthToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :height, :integer
    add_column :images, :width, :integer
  end

  def self.down
    remove_column :images, :height
    remove_column :images, :width
  end
end
