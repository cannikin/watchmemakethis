class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.text :description
      t.string :file
      t.integer :version
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
