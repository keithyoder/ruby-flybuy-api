# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'
require 'flybuy/client'

module Flybuy
  class SiteStoreHours
    include ::ActiveModel::Model
    include ::ActiveModel::Serializers::JSON
    include Flybuy::Base
    ATTRIBUTES = %i[id site_id holidays regular_hours pickup_type].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(client, hash)
      @client = client
      self.attributes = hash
    end

    def update(attributes = {})
      self.class.update(site_store_hours: self, attributes: attributes)
    end

    def attribute_list
      ATTRIBUTES
    end

    def self.find(id)
      client = Flybuy.client
      res = client.get("site_store_hours/#{id}")
      return res[:data].map { |data| Flybuy::SiteStoreHours.new(client, data) }  if res[:data].present?
    end

    def self.find_by_site(site_id)
      client = Flybuy.client
      res = client.get("sites/#{site_id}/site_store_hours")
      return res[:data].map { |data| Flybuy::SiteStoreHours.new(client, data) } if res[:data].present?
    end
  
    def self.create(hash)
      client = Flybuy.client
      response = client.post(
        "sites/#{hash[:site_id]}/site_store_hours/",
        {
          data: hash
        }
      )
      Flybuy::SiteStoreHours.new(@client, response)
    end

    def self.update(id: nil, site_store_hours: nil, attributes: {})
      @client = Flybuy.client
      site_store_hours_id = site_store_hours.present? ? site_store_hours.id : id
      response = @client.patch("site_store_hours/#{site_store_hours_id}", { data: attributes })
      if site_store_hours.present?
        site_store_hours.attributes = response[:data]
      else
        Flybuy::SiteStoreHours.new(@client, response[:data])
      end
    end
  end
end
