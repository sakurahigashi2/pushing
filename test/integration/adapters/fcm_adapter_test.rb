require 'integration/test_helper'
require 'integration/fcm_test_cases'

class FcmAdapterIntegrationTest < ActiveSupport::TestCase
  include FcmTestCases

  setup do
    Pushing.config.fcm.adapter = :fcm_gem
  end

  private

  def adapter
    'fcm'
  end

  def stub_url
    "https://fcm.googleapis.com/v1/projects/#{Pushing.config.fcm.firebase_project_id}/messages:send"
  end
end
