class AddImageOrderToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :image_order, :string, :default => 'desc'
  end
end
