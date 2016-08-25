# frozen_string_literal: true
module CMAPI
  module Refinements
    refine Object do
      def blank?
        respond_to?(:empty?) ? empty? : !self
      end

      def present?
        !blank?
      end
    end
  end
end
