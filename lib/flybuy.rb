# frozen_string_literal: true

require_relative './flybuy/base'
require_relative './flybuy/client'
require_relative './flybuy/version'
require_relative './flybuy/order'
require_relative './flybuy/site'

module Flybuy
  class << self
    def self.remove_dashes(partner_identifier)
      return partner_identifier if partner_identifier.split('-').size == 2

      partner_identifier.gsub('-', '').gsub('*', '-')
    end
  end
end
