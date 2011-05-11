class AddClientNameToBuilds < ActiveRecord::Migration
  def self.up
    add_column :builds, :client_name, :string
  end

  def self.down
    remove_column :builds, :client_name
  end
end
