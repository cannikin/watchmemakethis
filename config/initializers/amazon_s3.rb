# read /config/amazon_s3.yml and make the config options availalble to any controller that needs them
begin
  S3_CONFIG = YAML.load(ERB.new(File.read(File.join(Rails.root, 'config', 'amazon_s3.yml'))).result)[Rails.env].symbolize_keys
  AWS::S3::Base.establish_connection!(:access_key_id => S3_CONFIG[:access_key_id], :secret_access_key => S3_CONFIG[:secret_access_key])
rescue => e
  Rails.logger.error "Error while initializing S3 connection: #{e.message}: #{e.backtrace}"
end
