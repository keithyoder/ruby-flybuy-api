# frozen_string_literal: true

require 'httparty'

module Flybuy
  class Client
    include HTTParty
    FLYBUY_ENDPOINT = 'https://flybuy.radiusnetworks.com/api/v1/'
    def initialize(access_token = nil)
      @access_token = access_token || ENV['FLYBUY_ACCESS_TOKEN']
    end

    def get(path, query = {})
      url = "#{FLYBUY_ENDPOINT}#{path}"
      JSON.parse(
        HTTParty.get(url, headers: headers, query: query).body,
        symbolize_names: true
      )
    end

    def patch(path, body)
      url = "#{FLYBUY_ENDPOINT}#{path}"
      JSON.parse(
        HTTParty.patch(url, headers: headers, body: body).body,
        symbolize_names: true
      )
    end

    def post(path, body)
      url = "#{FLYBUY_ENDPOINT}#{path}"
      JSON.parse(
        HTTParty.post(url, headers: headers, body: body).body,
        symbolize_names: true
      )
    end

    private

    def headers
      {
        'Authorization' => "Token token=#{@access_token}"
      }
    end
  end
end
