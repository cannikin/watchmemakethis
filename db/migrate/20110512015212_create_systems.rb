class CreateSystems < ActiveRecord::Migration
  def self.up
    create_table :systems do |t|
      t.string  :twitter_username
      t.string  :next_twitter_call
      t.integer :twitpic_count,   :default => 0
      t.integer :yfrog_count,     :default => 0
      t.integer :instagram_count, :default => 0
    end
  end

  def self.down
    drop_table :systems
  end
end
