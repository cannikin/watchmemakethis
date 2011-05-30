class AddUploadMethodToImages < ActiveRecord::Migration
  def change
    add_column :images, :upload_method_id, :integer
    
    add_index :images, :upload_method_id
  end
end
