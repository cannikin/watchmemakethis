class SwitchStyleLinkToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :style_id, :integer
    remove_column :styles, :site_id
  end

  def self.down
    add_column :styles, :site_id, :integer
    remove_column :sites, :style_id
  end
end
