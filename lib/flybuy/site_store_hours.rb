# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'
require 'flybuy/client'
require 'biz'

module Flybuy
  class SiteStoreHours
    include ::ActiveModel::Model
    include ::ActiveModel::Serializers::JSON
    include Flybuy::Base
    ATTRIBUTES = %i[id site_id holidays regular_hours pickup_type].freeze
    attr_accessor(*ATTRIBUTES)

    DAYS_OF_WEEK = {
      '0': :sun,
      '1': :mon,
      '2': :tue,
      '3': :wed,
      '4': :thu,
      '5': :fri,
      '6': :sat,
    }.freeze  

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

    def currently_open?
      # Assume sites are open if they don't support store hours
      return true unless regular_hours.present?
  
      # currently we are missing the enabled attribute from the API
      #return false unless enabled?
  
      biz_schedule.in_hours?(Time.zone.now)
    end

    def site
      @site ||= Flybuy::Site.find(site_id)
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

    private

    def biz_schedule
      ::Biz::Schedule.new { |config|
        config.hours = regular_hours_to_biz
        config.time_zone = site.timezone
        config.holidays = holidays
      }
    end
  
    def regular_hours_to_biz
      return unless regular_hours.present?
  
      regular_hours.map { |key, values|
        [
          DAYS_OF_WEEK[key],
          values.map { |value| value.values_at(:open, :close) }.to_h,
        ]
      }.to_h
    end  
  end
end
