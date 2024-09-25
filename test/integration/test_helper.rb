require 'test_helper'
require 'webmock/minitest'

require 'notifiers/maintainer_notifier'
require 'notifiers/notifier_with_rescue_handler'

WebMock.allow_net_connect!

Pushing::Base.logger = Logger.new(STDOUT)
Pushing.configure do |config|
  config.fcm.google_application_credentials = ENV.fetch('FCM_TEST_GOOGLE_APPLICATION_CREDENTIALS')
  config.fcm.firebase_project_id            = ENV.fetch('FCM_TEST_FIREBASE_PROJECT_ID')


  config.apn.environment          = :development
  config.apn.certificate_path     = File.join(File.expand_path("./"), ENV.fetch('APN_TEST_CERTIFICATE_PATH'))
  config.apn.certificate_password = ENV.fetch('APN_TEST_CERTIFICATE_PASSWORD')
  config.apn.default_headers      = {
    apns_topic: ENV.fetch('APN_TEST_TOPIC')
  }
end
