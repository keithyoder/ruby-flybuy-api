# frozen_string_literal: true

module Flybuy
  class WebhookAuthentication
    include Flybuy::Base

    def initialize(request)
      @request = request
    end

    def authentic?(token = nil, hmac_key = nil)
      return true if token.empty? && hmac_key.empty?
      return false if token.present? && (token != authorization_token)

      if hmac_key.present?
        @hmac_key = Base64.decode64(hmac_key)
        return false if generate_signature(date_header, @request.body.string) != hmac_signature
      end

      true
    end

    private

    def date_header
      @request.headers.env['HTTP_DATE']
    end

    def authorization_token
      match = @request.headers.env['HTTP_AUTHORIZATION']&.match(/token="([^"]*?)"/)
      return match[1] if match.present?
    end

    def hmac_signature
      match = @request.headers.env['HTTP_AUTHORIZATION']&.match(/signature="([^"]*?)"/)
      return match[1] if match.present?
    end

    def generate_signature(*items)
      message = items.join("\n")
      Base64.strict_encode64(
        OpenSSL::HMAC.digest('sha256', @hmac_key, message)
      )
    end
  end
end
