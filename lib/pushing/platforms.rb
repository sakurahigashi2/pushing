# frozen-string-literal: true

require 'active_support/configurable'

module Pushing
  module Platforms
    include ActiveSupport::Configurable

    config.apn = ActiveSupport::OrderedOptions.new
    config.fcm = ActiveSupport::OrderedOptions.new

    class << self
      def lookup(platform_name)
        const_get(:"#{platform_name.capitalize}Payload")
      end
    end

    class ApnPayload
      attr_reader :payload, :device_token, :environment

      def initialize(payload, options)
        if options.is_a?(String)
          @device_token = options
        else options.is_a?(Hash)
          @device_token, @environment, @headers = options.values_at(:device_token, :environment, :headers)
        end

        @payload = payload
      end

      def recipients
        Array(@device_token) # TODO: make sure device tokens can be an array
      end

      def headers
        @normalized_headers ||= begin
                                  h = @headers.stringify_keys.transform_keys!(&:dasherize)

                                  {
                                    authorization:      h['authorization'],
                                    'apns-id':          h['apns-id']          || h['id'],
                                    'apns-expiration':  h['apns-expiration']  || h['expiration'],
                                    'apns-priority':    h['apns-priority']    || h['priority'],
                                    'apns-topic':       h['apns-topic']       || h['topic'],
                                    'apns-collapse-id': h['apns-collapse-id'] || h['collapse-id'],
                                  }
                                end
      end
    end

    class FcmPayload
      attr_reader :payload

      def initialize(payload, *)
        @payload = payload
      end

      def recipients
        # TODO: make sure the :to key can hold an array
        Array(payload['to'] || payload['registration_ids'])
      end
    end
  end

  class DeliveryError < RuntimeError
    attr_reader :response, :notification

    def initialize(message, response = nil, notification = nil)
      super(message)
      @response = response
      @notification = notification
    end
  end

  class ApnDeliveryError < DeliveryError
  end

  class FcmDeliveryError < DeliveryError
  end
end
