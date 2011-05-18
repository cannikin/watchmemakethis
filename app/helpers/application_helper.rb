module ApplicationHelper
  
  # output a list of error messages for the given field
  def field_errors(obj, field)
    if obj.errors.has_key? field
      output = '<ul class="errors">'
      obj.errors[field].each do |message| 
        output += "<li>" + message + "</li>"
      end
      output += "</ul>"
      return output.html_safe
    end
  end
  
end
