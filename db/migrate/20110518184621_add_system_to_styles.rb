class AddSystemToStyles < ActiveRecord::Migration
  def self.up
    add_column :styles, :system, :boolean, :default => :false
  end

  def self.down
    remove_column :styles, :system
  end
end
