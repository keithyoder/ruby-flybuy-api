# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'
require 'flybuy/client'

module Flybuy
  class ArchivedOrder
    include ::ActiveModel::Model
    include ::ActiveModel::Serializers::JSON
    include Flybuy::Base
    ATTRIBUTES = %i[type id archived_at arrived_at completed_at customer_rating_comments customer_rating_value
                    customer_state eta_at expired_at location_permission location_started_at order_reminder_at
                    partner_identifier partner_identifier_for_crew partner_identifier_for_customer payment_method
                    pickup_type pickup_window postarrival_at prearrival_at project_name redeemed_at sdk_platform
                    sdk_os_version sdk_version site_name site_operational_status site_partner_identifier
                    sms_delivered_timestamps sms_failed_timestamps sms_undelivered_timestamps timezone
                    trip_distance_meters viewed_timestamps wait_time_seconds waiting_at wrong_site_arrival_at
                    wrong_site_id app_authorization_id customer_id project_id site_id created_at updated_at
                    delivery_source].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(client, hash)
      @client = client
      self.attributes = hash
    end

    def attribute_list
      ATTRIBUTES
    end

    def self.all(range)
      fetch(range) { |result| result.collect { |ao| Flybuy::ArchivedOrder.new(@client, ao) } }
    end

    def self.hash(range)
      fetch(range) { |result| result }
    end

    def self.find_by_partner_identifier(partner_identifier, range)
      client = Flybuy.client
      res = client.get(
        'archived_orders',
        {
          partner_identifier: partner_identifier,
          start_time: range.begin.iso8601,
          end_time: range.end.iso8601
        }
      )
      return Flybuy::ArchivedOrder.new(client, res[:data].first) if res[:data].present?
    end

    private

    def self.fetch(range)
      @client = Flybuy.client
      @archived_orders = []
      next_url = "archived_orders?start_time=#{range.begin.iso8601}&end_time=#{range.end.iso8601}"
      until next_url.nil?
        response = @client.get(next_url.gsub(@client.url, ''))
        @archived_orders.concat(
          yield(response[:data])
        )
        next_url = response[:pages][:next]
      end
      @archived_orders
    end
  end
end
