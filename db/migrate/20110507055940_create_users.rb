class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.string :twitter
      t.integer :role_id
      t.datetime :last_login_at
      t.integer :login_count

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
