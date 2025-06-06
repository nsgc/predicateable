# frozen_string_literal: true

require_relative "predicateable/version"

module Predicateable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def predicate(name, values, prefix: false, strict: false)
      values.each do |value|
        method = prefix ? "#{name}_#{value}?" : "#{value}?"

        define_method(method) do
          actual = send(name)

          if strict
            actual == value
          else
            actual.to_s == value.to_s
          end
        end
      end
    end
  end
end
