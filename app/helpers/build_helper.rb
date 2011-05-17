module BuildHelper
  
  def compute_width_height(image)
    a = image.width
    b = image.height
    if a > b
      thumb_a = 250
      thumb_b = b * thumb_a / a
    elsif b > a
      thumb_b = 250
      thumb_a = a * thumb_b / b
    else
      thumb_a = thumb_b = 250
    end
    return { :width => thumb_a, :height => thumb_b }
  end
  
end
