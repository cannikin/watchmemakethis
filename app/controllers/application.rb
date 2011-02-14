# styles
get '/stylesheets/shared.css' do
  # response['Expires'] = (Time.now + 60*60*24*356*3).httpdate
  sass :'stylesheets/shared'
end
