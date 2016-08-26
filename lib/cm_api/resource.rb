# frozen_string_literal: true
module CMAPI
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
