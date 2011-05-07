class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.integer :user_id
      t.integer :build_id

      t.timestamps
    end
    
    add_index :clients, :user_id
    add_index :clients, :build_id
    add_index :clients, [:user_id, :build_id]
    add_index :clients, [:build_id, :user_id]
  end

  def self.down
    drop_table :clients
  end
end
