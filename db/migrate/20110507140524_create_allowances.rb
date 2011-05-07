class CreateAllowances < ActiveRecord::Migration
  def self.up
    create_table :allowances do |t|
      t.string :role_id
      t.string :permission_id

      t.timestamps
    end
  end

  def self.down
    drop_table :allowances
  end
end
