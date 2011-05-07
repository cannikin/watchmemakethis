class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.integer :user_id
      t.string :name
      t.string :path
      t.boolean :show_in_directory

      t.timestamps
    end
    
    add_index :sites, :user_id
    add_index :sites, :path
  end

  def self.down
    drop_table :sites
  end
end
