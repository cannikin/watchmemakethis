Sequel.migration do
  up do
    create_table(:clients) do
      primary_key :id
      Integer     :site_id
      String      :first_name
      String      :last_name
      String      :email                            # required for login
      String      :hashtag                          # hashtag to tweet pictures to
      String      :twitter                          # user's twitter handle if they want twitter updates from @watchmemake
      Integer     :user_id                          # user who created this client
      Boolean     :archived,      :default => false # whether or not this site is displayed
      Boolean     :public,        :default => false # whether to show this client on the site's homepage
      String      :last_login_at
      Integer     :login_count,   :default => 0
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
