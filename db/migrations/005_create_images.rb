Sequel.migration do
  up do
    create_table(:images) do
      primary_key :id
      Integer     :user_id
      Integer     :build_id
      String      :filename
      String      :created_at
      
      index :user_id
      index :build_id
    end
  end

  down do
    drop_table(:sites)
  end
end
