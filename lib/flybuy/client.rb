# frozen_string_literal: true

require 'net/http'

module Flybuy
  class Client
    FLYBUY_ENDPOINT = 'https://flybuy.radiusnetworks.com/api/v1/'
    def initialize(access_token = nil)
      @access_token = access_token || ENV['FLYBUY_ACCESS_TOKEN']
    end

    def get(path, query = {})
      uri = URI("#{FLYBUY_ENDPOINT}#{path}")
      uri.query = URI.encode_www_form(query) unless query == {}
      perform_request(uri, Net::HTTP::Get.new(uri))
    end

    def patch(path, body)
      uri = URI("#{FLYBUY_ENDPOINT}#{path}")
      perform_request(uri, Net::HTTP::Patch.new(uri), body)
    end

    def post(path, body)
      uri = URI("#{FLYBUY_ENDPOINT}#{path}")
      perform_request(uri, Net::HTTP::Post.new(uri), body)
    end

    def put(path, body)
      uri = URI("#{FLYBUY_ENDPOINT}#{path}")
      perform_request(uri, Net::HTTP::Put.new(uri), body)
    end

    private

    def authorization
      "Token token=#{@access_token}"
    end

    def perform_request(uri, req, body = nil)
      req.body = body.to_json unless body.nil?
      req['Authorization'] = authorization
      req['Content-type'] = 'application/json'
      parse_response(
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
      )
    end

    def parse_response(res)
      parsed_response = JSON.parse(res.body, symbolize_names: true) if res.body.present?
      unless res.is_a?(Net::HTTPSuccess) && (parsed_response.blank? || parsed_response.keys.exclude?(:errors))
        raise StandardError, parsed_response
      end

      parsed_response
    end
  end
end
