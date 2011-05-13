class AddTweetIdToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :tweet_id, :string
  end

  def self.down
    remove_column :images, :tweet_id
  end
end
