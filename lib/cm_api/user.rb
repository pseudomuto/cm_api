# frozen_string_literal: true
module CMAPI
  # A class that represents a CDM user. This class will delegate calls to a {Resource} object when a method is not
  # defined here.
  class User < SimpleDelegator
  end
end
