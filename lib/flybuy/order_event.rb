# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'

module Flybuy
  class OrderEvent
    include Flybuy::Base

    def self.update_order_state(order_id: nil, order_state: nil, client: nil) # rubocop:disable Metrics/MethodLength
      client ||= Flybuy.client
      client.post(
        'events/',
        {
          data: {
            order_id: order_id,
            event_type: 'state_change',
            state: order_state
          }
        }
      )
    end

    def self.update_customer_state(order_id: nil, customer_state: nil, eta_seconds: nil, client: nil) # rubocop:disable Metrics/MethodLength
      client ||= Flybuy.client
      client.post(
        'events/',
        {
          data: {
            order_id: order_id,
            event_type: 'state_change',
            customer_state: customer_state,
            eta_seconds: eta_seconds
          }
        }
      )
    end

    def self.update_customer_rating(order_id: nil, customer_rating_value: nil, customer_rating_comments: nil, client: nil) # rubocop:disable Metrics/MethodLength
      client ||= Flybuy.client
      client.post(
        'events/',
        {
          data: {
            order_id: order_id,
            event_type: 'customer_rating',
            customer_rating_value: customer_rating_value,
            customer_rating_comments: customer_rating_comments
          }
        }
      )
    end
  end
end
