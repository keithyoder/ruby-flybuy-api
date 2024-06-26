# frozen_string_literal: true

require_relative './flybuy/base'
require_relative './flybuy/client'
require_relative './flybuy/version'
require_relative './flybuy/order'
require_relative './flybuy/order_event'
require_relative './flybuy/site'
require_relative './flybuy/site_store_hours'
require_relative './flybuy/archived_order'
require_relative './flybuy/customer'
require_relative './flybuy/webhook_authentication'

module Flybuy
  class << self
    attr_reader :client

    def self.remove_dashes(partner_identifier)
      return partner_identifier if partner_identifier.split('-').size == 2

      partner_identifier.gsub('-', '').gsub('*', '-')
    end
  end

  def self.token=(flybuy_token)
    @client = Flybuy::Client.new(flybuy_token)
  end
end
