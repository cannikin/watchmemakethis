Sequel.migration do
  up do
    create_table(:sites) do
      primary_key :id
      Integer     :user_id
      String      :body_color
      String      :header_color
      String      :text_color
      
      index :user_id
    end
  end

  down do
    drop_table(:sites)
  end
end
