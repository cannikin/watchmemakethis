class AddFontsToStyles < ActiveRecord::Migration
  def self.up
    add_column :styles, :header_font_family, :string
    add_column :styles, :header_font_size, :string
    add_column :styles, :body_font_family, :string
    add_column :styles, :body_font_size, :string
  end

  def self.down
    remove_column :styles, :header_font_family
    remove_column :styles, :header_font_size
    remove_column :styles, :body_font_family
    remove_column :styles, :body_font_size
  end
end
