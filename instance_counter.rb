# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||= 0
    end

    def increase_instances
      self.instances += 1
    end

    protected

    attr_writer :instances
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.increase_instances
    end
  end
end
