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
        send "#{validator[1]}_validation".to_sym, name, var, *validator[2..-1]
      end
    end

    def presence_validation(name, var)
      raise "#{name} не должен быть nil или пустой строкой" if var.nil? ||
                                                               var == ''
    end

    def format_validation(name, var, format)
      raise "#{name} не соответсвует формату" if var !~ format
    end

    def type_validation(name, var, type)
      raise "#{name} должен быть #{type}" unless var.is_a? type
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
