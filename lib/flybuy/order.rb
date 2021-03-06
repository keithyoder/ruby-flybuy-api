# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'
require 'flybuy/client'

module Flybuy
  class Order
    include ::ActiveModel::Model
    include ::ActiveModel::Serializers::JSON
    include Flybuy::Base
    ATTRIBUTES = %i[order_id order_state created redemption_url customer_state arrived_at eta_at partner_identifier
                    partner_identifier_for_crew partner_identifier_for_customer redemption_code created_at updated_at
                    area_name possible_areas customer_id site_id site_partner_identifier spot_identifier
                    customer_name customer_car_type customer_car_color customer_license_plate customer_rating_value
                    customer_rating_comments pickup_window pickup_type push_token tag_ids delivery_error_reviewed_at
                    delivery_errored_at delivery_identifier delivery_source].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(client: nil, data: nil)
      @client = client || Flybuy.client
      return if data.nil?

      self.attributes = data
    end

    def attribute_list
      ATTRIBUTES
    end

    def self.find_by_partner_identifier(partner_identifier)
      client = Flybuy.client
      response = client.get('orders', { partner_identifier: partner_identifier })
      return nil if response[:data].empty?

      Flybuy::Order.new(client: client, data: response[:data].first)
    end

    def self.find(id)
      client = Flybuy.client
      response = client.get("orders/#{id}")
      return nil if response[:data].empty?

      Flybuy::Order.new(client: client, data: response[:data])
    end

    def update_order_state(new_state)
      return if order_id.nil?

      Flybuy::OrderEvent.update_order_state(
        order_id: order_id,
        order_state: new_state,
        client: @client
      )
    end
  end
end
