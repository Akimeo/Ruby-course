# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        var_history_name = "@#{name}_history".to_sym
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(var_name, value)
          send("#{name}_history".to_sym).push(instance_variable_get(var_name))
        end
        define_method("#{name}_history".to_sym) do
          instance_variable_set(var_history_name, []) if
          instance_variable_get(var_history_name).nil?
          instance_variable_get(var_history_name)
        end
      end
    end

    def strong_attr_accessor(name, var_class)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        raise 'Тип присваемоего значения отличается от типа переменной' unless
        value.is_a? var_class

        instance_variable_set(var_name, value)
      end
    end
  end
end
