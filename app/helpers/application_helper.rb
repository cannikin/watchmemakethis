module ApplicationHelper
  
  # output a list of error messages for the given field
  def field_errors(obj, field)
    if obj.errors[field]
      output = '<ul class="errors">'
      obj.errors[field].each do |message| 
        output += "<li>" + message + "</li>"
      end
      output += "</ul>"
      return output.html_safe
    end
  end
  
  
  # fix for IE to recognize HTML5 tags
  def ie_html5_fix
    '<!--[if IE]>
      <script type="text/javascript">
        document.createElement("time");
        document.createElement("header");
        document.createElement("footer");
        document.createElement("nav");
        document.createElement("article");
        document.createElement("section");
      </script>
    <![endif]-->'.html_safe
  end
  
end
