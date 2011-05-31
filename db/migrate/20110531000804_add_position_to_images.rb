class AddPositionToImages < ActiveRecord::Migration
  def change
    add_column :images, :position, :integer
    
    Build.all.each do |build|
      build.images.order('created_at asc, id asc').each_with_index do |image,i|
        image.update_attributes :position => i+1
      end
    end
  end
end
