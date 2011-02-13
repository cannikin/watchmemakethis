Sequel.migration do
  up do
    create_table(:comments) do
      primary_key :id
      Integer     :image_id
      String      :body
      String      :from         # the name of the user that created the comment, copied from first_name, last_name
      String      :created_at
      
      index :image_id
    end
  end

  down do
    drop_table(:sites)
  end
end
