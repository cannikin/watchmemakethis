class AddIsAdminToUsers < ActiveRecord::Migration
  def up
    add_column :users, :is_admin, :boolean, :default => false
    User.first.update_attribute :is_admin, true
  end
  
  def down
    remove_column :users, :is_admin
  end
end
