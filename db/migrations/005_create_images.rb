Sequel.migration do
  up do
    create_table(:images) do
      primary_key :id
      Integer     :user_id
      Integer     :client_id
      String      :filename
      String      :created_at
      
      index :user_id
      index :client_id
    end
  end

  down do
    drop_table(:sites)
  end
end
