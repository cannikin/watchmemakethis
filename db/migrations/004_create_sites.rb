Sequel.migration do
  up do
    create_table(:sites) do
      primary_key :id
      Integer     :user_id
      String      :name
      String      :path
      String      :body_color
      String      :header_color
      String      :text_color
      Integer     :image_id                             # logo
      Boolean     :show_in_directory, :default => false # whether or not we can show the site in the directory
      DateTime    :created_at
      
      index :user_id
      index :path
      index :image_id
    end
  end

  down do
    drop_table(:sites)
  end
end
