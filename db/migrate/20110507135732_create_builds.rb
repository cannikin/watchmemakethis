class CreateBuilds < ActiveRecord::Migration
  def self.up
    create_table :builds do |t|
      t.integer :site_id
      t.string :name
      t.string :path
      t.string :hashtag
      t.boolean :archived,      :default => false
      t.boolean :public,        :default => true
      t.datetime :last_login_at
      t.integer :views,         :default => 0

      t.timestamps
    end
    
    add_index :builds, :site_id
    add_index :builds, :path
    add_index :builds, :hashtag
  end

  def self.down
    drop_table :builds
  end
end
