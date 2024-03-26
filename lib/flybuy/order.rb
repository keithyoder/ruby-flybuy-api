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
                    delivery_errored_at delivery_identifier delivery_source pos_identifier pay_state].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(client: nil, data: nil)
      @client = client || Flybuy.client
      return if data.nil?

      self.attributes = data
    end

    def attribute_list
      ATTRIBUTES
    end

    def self.create(**params)
      client = Flybuy.client
      response = client.post(create_endpoint(params), create_or_update_payload(params))
      return nil if response[:data].empty?

      Flybuy::Order.new(client: client, data: response[:data])
    end

    def self.find_by_partner_identifier(partner_identifier, all: false)
      client = Flybuy.client
      response = client.get('orders', { partner_identifier: partner_identifier })
      return nil if response[:data].empty?

      orders = response[:data].map { |order| Flybuy::Order.new(client: client, data: order) }
      return orders if all

      # initial versions of the gem only returned one order.  Defaulting to all: false maintains compatibility.
      orders.first
    end

    def self.find(id)
      client = Flybuy.client
      response = client.get("orders/#{id}")
      return nil if response[:data].empty?

      Flybuy::Order.new(client: client, data: response[:data])
    end

    def update(**params)
      return if order_id.nil?

      client = Flybuy.client
      response = client.put("orders/#{order_id}", Flybuy::Order.create_or_update_payload(params))
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

    def update_customer_state(new_state, spot_identifier: nil)
      return if order_id.nil?

      Flybuy::OrderEvent.update_customer_state(
        order_id: order_id,
        customer_state: new_state,
        spot_identifier: spot_identifier,
        client: @client
      )
    end

    def update_location(eta_seconds: nil, longitude: nil, latitude: nil, accuracy: nil, speed: nil)
      return if order_id.nil?

      Flybuy::OrderEvent.update_location(
        order_id: order_id,
        eta_seconds: eta_seconds,
        longitude: longitude,
        latitude: latitude,
        accuracy: accuracy,
        speed: speed,
        client: @client
      )
    end

    def self.create_endpoint(params)
      return 'orders?include=tags' if params.key?(:taggable_keywords)

      'orders'
    end

    def self.create_or_update_payload(params)
      {
        data: params.except(:taggable_keywords),
        metadata: {
          taggable_keywords: params[:taggable_keywords]
        }
      }
    end
  end
end
