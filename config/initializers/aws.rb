begin
  AWS_CONFIG = YAML.load(ERB.new(File.read(File.join(Rails.root, 'config', 'aws.yml'))).result)[Rails.env].symbolize_keys
  AWS_CONFIG.values.select { |v| v.is_a? Hash }.each { |h| h.symbolize_keys! }
    
  AWS::S3::Base.establish_connection!(:access_key_id => AWS_CONFIG[:access_key_id], :secret_access_key => AWS_CONFIG[:secret_access_key])
  SES = AWS::SES::Base.new(:access_key_id => AWS_CONFIG[:access_key_id], :secret_access_key => AWS_CONFIG[:secret_access_key])
  ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base, :access_key_id => AWS_CONFIG[:access_key_id], :secret_access_key => AWS_CONFIG[:secret_access_key]
rescue => e
  Rails.logger.error "Error while initializing AWS connections: #{e.message}: #{e.backtrace}"
end
