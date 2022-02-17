# frozen_string_literal: true

module Flybuy
  module Base
    def attributes=(hash)
      return if hash.nil?

      unknown_attributes = hash.keys - attribute_list
      unknown_attributes.each { |key| hash.delete(key) }
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def attributes
      instance_values.reject { |key, _| key == 'client' }
    end
  end
end
