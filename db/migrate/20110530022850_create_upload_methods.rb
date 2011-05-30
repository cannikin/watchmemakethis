class CreateUploadMethods < ActiveRecord::Migration
  def change
    create_table :upload_methods do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    
    UploadMethod.create([
      { :id => 1, :name => 'twitter', :description => 'Uploaded from twitter' },
      { :id => 2, :name => 'email',   :description => 'Uploaded from an email' },
      { :id => 3, :name => 'direct',  :description => 'Uploaded directly from the site' }
    ])
  end
end
