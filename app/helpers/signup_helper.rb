module SignupHelper
  
  def extract_style_attributes(style)
    style.attributes.reject do |attr|
      ['created_at','updated_at','system','id','name'].include? attr
    end
  end
  
end
