class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      t.integer :site_id
      t.string :header_background
      t.string :header_text_color
      t.string :body_background
      t.string :body_text_color
      t.string :image_border

      t.timestamps
    end
  end

  def self.down
    drop_table :styles
  end
end
