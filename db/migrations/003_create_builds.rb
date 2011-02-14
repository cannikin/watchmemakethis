Sequel.migration do
  up do
    create_table(:builds) do
      primary_key :id
      Integer     :user_id                          # user who created this build
      Integer     :site_id
      String      :name
      String      :hashtag                          # hashtag to tweet pictures to
      Boolean     :archived,      :default => false # whether or not this site is displayed
      Boolean     :public,        :default => false # whether to show this client on the site's homepage
      String      :last_login_at
      Integer     :views,         :default => 0
      String      :created_at
      
      index :user_id
      index :site_id
      index :hashtag
    end
  end

  down do
    drop_table(:builds)
  end
end
