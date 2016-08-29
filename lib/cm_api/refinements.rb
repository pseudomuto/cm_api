# frozen_string_literal: true
module CMAPI
  # A module of refinements used in this gem. Ideally this remains very small, but this will be used over monkey
  # patching
  #
  # @!visibility private
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
