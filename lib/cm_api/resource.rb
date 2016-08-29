# frozen_string_literal: true
module CMAPI
  # A container class for all responses
  #
  # This class will convert json responses into objects that respond to methods with the same name as the JSON
  # properties returned.
  #
  # @example
  #   # a simple json object
  #   resource = Resource.new('{"message": "value"}')
  #   resource.message #=> "value"
  #
  # @example
  #   # a json object with nested properties
  #   json = <<-EOF
  #   {
  #     "items": [
  #       { "name": "test", "values": [1, 2, 3], "child": { "key": "value" } }
  #     ]
  #   }
  #   EOF
  #
  #   resource = Resource.new(JSON.parse(json))
  #   resource.items.size              #=> 1
  #   resource.items.first.values.last #=> 3
  #   resource.items.first.child.key   #=> "value"
  class Resource
    class << self
      private

      def dynamic_accessor(*attrs)
        attrs.each do |attr|
          class_eval do
            define_method(attr) { _attributes[attr] }
            define_method("#{attr}=") { |value| _attributes[attr] = value }
            define_method("#{attr}?") { !!_attributes[attr] }
          end
        end
      end
    end

    # Creates a new resource
    #
    # @param json [Hash] a json object
    def initialize(json)
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
      when Hash then self.class.new(attr)
      when Array then attr.map(&method(:parse_attribute))
      else attr
      end
    end
  end
end
