# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'
require 'flybuy/client'

module Flybuy
  class Site
    include ::ActiveModel::Model
    include ::ActiveModel::Serializers::JSON
    include Flybuy::Base
    ATTRIBUTES = %i[name partner_identifier project_id project_name premises_coordinates overlay_photo_url
                    overlay_photo_coordinates id full_address latitude longitude instructions description
                    phone nearby_minutes customer_sms_notifications_config customer_sms_notifications_whitelist
                    drive_thru_type order_created_minutes order_reminder_minutes postarrival_seconds
                    prearrival_seconds prearrival_tag_ids operational_status timezone].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(client, hash)
      @client = client
      self.attributes = hash
    end

    def attribute_list
      ATTRIBUTES
    end

    def self.all(token)
      @client = Flybuy::Client.new(token)
      @sites = []
      next_url = 'sites/'
      until next_url.nil?
        response = @client.get(next_url.gsub(Flybuy::Client::FLYBUY_ENDPOINT, ''))
        @sites.concat(response[:data].collect { |site| Flybuy::Site.new(@client, site) })
        next_url = response[:pages][:next]
      end
      @sites
    end
  end
end
