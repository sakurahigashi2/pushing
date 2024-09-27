module FcmTestCases
  def test_actually_push_notification
    responses = MaintainerNotifier.build_result(adapter, fcm: true).deliver_now!
    response  = responses.first

    assert_equal 200, response.code
    assert_equal   1, response.json[:success]
    assert_equal "application/json; charset=UTF-8", response.headers["content-type"]
  end

  class FcmTokenHandler
    cattr_accessor :canonical_ids
    self.canonical_ids = []

    def delivered_notification(payload, response)
      response.json[:results].select {|result| result[:registration_id] }.each do |result|
        self.class.canonical_ids << result[:registration_id]
      end
    end
  end

  def test_observer_can_observe_responses_from_fcm
    MaintainerNotifier.register_observer FcmTokenHandler.new

    stub_request(:post, stub_url).to_return(
      status: 200,
      headers: {},
      body: {
        multicast_id: 216,
        success: 3,
        failure: 3,
        canonical_ids: 1,
        results: [
          { message_id: "1:0408" },
          { error: "Unavailable" },
          { error: "InvalidRegistration" },
          { message_id: "1:1516" },
          { message_id: "1:2342", registration_id: "32" },
          { error: "NotRegistered"}
        ]
      }.to_json
    )

    MaintainerNotifier.build_result(adapter, fcm: true).deliver_now!

    assert_equal ["32"], FcmTokenHandler.canonical_ids
  ensure
    FcmTokenHandler.canonical_ids.clear
    MaintainerNotifier.delivery_notification_observers.clear
  end

  def test_notifier_raises_exception_on_http_client_error
    stub_request(:post, stub_url).to_return(status: 400)

    error = assert_raises Pushing::FcmDeliveryError do
      MaintainerNotifier.build_result(adapter, fcm: true).deliver_now!
    end

    assert_equal 400, error.response.code
    assert_equal true, error.notification.payload[:dry_run]
  end

  def test_notifier_can_rescue_error_on_error_response
    stub_request(:post, stub_url).to_return(status: 400)

    assert_nothing_raised do
      NotifierWithRescueHandler.fcm.deliver_now!
    end

    response = NotifierWithRescueHandler.last_response_from_fcm
    assert_equal 400, response.code
  end

  def adapter
    raise NotImplementedError
  end

  def stub_url
    raise NotImplementedError
  end

end
