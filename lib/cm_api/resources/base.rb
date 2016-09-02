# frozen_string_literal: true
module CMAPI
  module Resources
    # A base class for for API responses
    #
    # This class will convert json responses into objects that respond to methods with the same name as the JSON
    # properties returned (only snake_cased because Ruby).
    #
    # @example
    #   # a simple json object
    #   resource = Base.new('{"someMessage": "value"}')
    #   resource.some_message #=> "value"
    #
    # @example
    #   # a json object with nested properties
    #   json = <<-EOF
    #   {
    #     "items": [
    #       { "name": "test", "values": [1, 2, 3], "child": { "keyName": "value" } }
    #     ]
    #   }
    #   EOF
    #
    #   resource = Base.new(JSON.parse(json))
    #   resource.items.size                 #=> 1
    #   resource.items.first.values.last    #=> 3
    #   resource.items.first.child.key_name #=> "value"
    class Base
      class << self
        private

        def dynamic_accessor(*attrs)
          attrs.each do |attr|
            attr_name = attr.gsub(/([A-Z]+)/, "_\\1").downcase

            class_eval do
              define_method(attr_name) { _attributes[attr] }
              define_method("#{attr_name}=") { |value| _attributes[attr] = value }
              define_method("#{attr_name}?") { !!_attributes[attr] }
            end
          end
        end
      end

      # @return [Client] the API client that initiated the request
      attr_reader :api_client

      # Creates a new resource
      #
      # @param json [Hash] a json object
      # @param api_client [Client] the API client that initiated the request
      def initialize(json, api_client:)
        @api_client = api_client
        json.each { |key, value| _attributes[key] = parse_attribute(value) }

        metaclass = (class << self; self; end)
        metaclass.send(:dynamic_accessor, *_attributes.keys)
      end

      private

      def _attributes
        @_attributes ||= {}
      end

      def parse_attribute(attr)
        case attr
        when Hash then self.class.new(attr, api_client: api_client)
        when Array then attr.map(&method(:parse_attribute))
        else attr
        end
      end
    end
  end
end
