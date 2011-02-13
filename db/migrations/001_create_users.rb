Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String      :first_name
      String      :last_name
      String      :email
      String      :password
      String      :twitter
      Integer     :role_id
      DateTime    :last_login_at
      Integer     :login_count, :default => 0
      DateTime    :created_at
      
      index :email
      index [:email, :password]
      index :twitter
      index :role_id
    end
  end

  down do
    drop_table(:users)
  end
end
