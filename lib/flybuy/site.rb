# frozen_string_literal: true

require 'active_model'
require 'flybuy/base'
require 'flybuy/client'
require 'flybuy/sites_list'

module Flybuy
  class Site
    include ::ActiveModel::Model
    include ::ActiveModel::Serializers::JSON
    include ActiveModel::Dirty
    include Flybuy::Base
    ATTRIBUTES = %i[name partner_identifier project_id project_name premises_coordinates overlay_photo_url
                    overlay_photo_coordinates id full_address latitude longitude instructions description
                    phone nearby_minutes customer_sms_notifications_config customer_sms_notifications_whitelist
                    drive_thru_type order_created_minutes order_reminder_minutes postarrival_seconds
                    prearrival_seconds prearrival_tag_ids operational_status timezone].freeze
    attr_accessor(*ATTRIBUTES)

    define_attribute_methods :name, :partner_identifier

    def initialize(client, hash)
      @client = client
      self.attributes = hash
    end

    def attribute_list
      ATTRIBUTES
    end

    def partner_identifier_without_dashes
      return if @partner_identifier.nil?
      return @partner_identifier if @partner_identifier.split('-').size == 2

      @partner_identifier.gsub('-', '').gsub('*', '-')
    end

    def update(attributes = {})
      self.class.update(site: self, attributes: attributes)
    end

    def self.all
      @client = Flybuy.client
      @sites = Flybuy::SitesList.new
      next_url = 'sites/'
      until next_url.nil?
        response = @client.get(next_url.gsub(Flybuy::Client::FLYBUY_ENDPOINT, ''))
        @sites.concat(response[:data].collect { |site| Flybuy::Site.new(@client, site) })
        next_url = response[:pages][:next]
      end
      @sites
    end

    def self.find_by_partner_identifier(partner_identifier)
      client = Flybuy.client
      res = client.get('sites', { partner_identifier: partner_identifier })
      return Flybuy::Site.new(client, res[:data].first) if res[:data].present?
    end

    def self.find(site_id)
      client = Flybuy.client
      res = client.get("sites/#{site_id}")
      return Flybuy::Site.new(client, res[:data]) if res[:data].present?
    end

    def self.create(hash)
      response = @client.post(
        'sites/',
        {
          data: hash
        }
      )
      Flybuy::Site.new(@client, response)
    end

    def self.update(id: nil, site: nil, attributes: {})
      @client = Flybuy.client
      site_id = site.present? ? site.id : id
      response = @client.patch("sites/#{site_id}", { data: attributes })
      if site.present?
        site.attributes = response[:data]
      else
        Flybuy::Site.new(@client, response[:data])
      end
    end
  end
end
