class CreateComps < ActiveRecord::Migration
  def self.up
    create_table :comps do |t|
      t.string :title
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comps
  end
end
