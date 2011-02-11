Sequel.migration do
  up do
    create_table(:clients) do
      primary_key :id
      Integer     :site_id
      String      :name
      String      :email          # required for login
      String      :hashtag        # hashtag to tweet pictures to
      String      :twitter        # user's twitter handle if they want twitter updates from @watchmemake
      Integer     :user_id        # user who created this client
      String      :last_login_at
      Integer     :login_count
      String      :created_at
      
      index :site_id
      index :hashtag
      index :twitter
      index :email
    end
  end

  down do
    drop_table(:clients)
  end
end
