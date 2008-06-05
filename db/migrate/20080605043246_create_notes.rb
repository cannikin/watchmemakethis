class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text :note
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height
      t.integer :version_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
