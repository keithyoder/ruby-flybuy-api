# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'
require 'flybuy/client'

module Flybuy
  class Customer
    include ::ActiveModel::Model
    include ::ActiveModel::Serializers::JSON
    include Flybuy::Base
    ATTRIBUTES = %i[id api_token car_color car_type license_plate name phone partner_identifier
                    created_at updated_at].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(client, hash)
      @client = client
      self.attributes = hash
    end

    def attribute_list
      ATTRIBUTES
    end

    def self.find(id)
      client = Flybuy.client
      res = client.get("customers/#{id}")
      return Flybuy::Customer.new(client, res[:data]) if res[:data].present?
    end
  end
end
