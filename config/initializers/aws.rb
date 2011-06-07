begin; root = Rails.root; rescue; root = ROOT; end
begin; env = Rails.env; rescue; env = ENV['RAILS_ENV']; end
begin; logger = Rails.logger; rescue; logger = LOGGER; end

begin
  AWS_CONFIG = YAML.load(File.read(File.join(root, 'config', 'aws.yml')))[env]
  # AWS_CONFIG.values.select { |v| v.is_a? Hash }.each { |h| h.symbolize_keys! }
    
  AWS::S3::Base.establish_connection!(:access_key_id => AWS_CONFIG['access_key_id'], :secret_access_key => AWS_CONFIG['secret_access_key'])
  SES = AWS::SES::Base.new(:access_key_id => AWS_CONFIG['access_key_id'], :secret_access_key => AWS_CONFIG['secret_access_key'])
  ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base, :access_key_id => AWS_CONFIG['access_key_id'], :secret_access_key => AWS_CONFIG['secret_access_key']
rescue => e
  logger.error "Error while initializing AWS connections: #{e.message}: #{e.backtrace}"
end
