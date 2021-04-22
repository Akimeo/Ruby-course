# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validators
      @validators ||= superclass.validators if
      superclass.respond_to? :validators
      @validators ||= []
    end

    def validate(*args)
      validators.push(args)
    end
  end

  module InstanceMethods
    def validate!
      self.class.validators.each do |validator|
        name = validator[0]
        var = instance_variable_get("@#{name}".to_sym)
        case validator[1]
        when :presence
          raise "#{name} не должен быть nil или пустой строкой" if var.nil? ||
                                                                   var == ''
        when :format
          raise "#{name} не соответсвует формату" if var !~ validator[2]
        when :type
          raise "#{name} должен быть #{validator[2]}" unless
          var.is_a? validator[2]
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
