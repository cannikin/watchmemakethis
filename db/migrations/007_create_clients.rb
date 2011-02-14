Sequel.migration do
  up do
    create_table(:clients) do
      primary_key :id
      Integer     :user_id
      Integer     :build_id
      String      :created_at
      
      index :user_id
      index :build_id
      index [:user_id, :build_id]
      index [:build_id, :user_id]
    end
  end

  down do
    drop_table(:clients)
  end
end
