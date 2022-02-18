# frozen_string_literal: true

module Flybuy
  class SitesList < Array
    def find(partner_identifier)
      detect { |site| partner_identifier == site.partner_identifier_without_dashes }
    end

    def live
      select { |site| site.operational_status == 'live' }
    end
  end
end
