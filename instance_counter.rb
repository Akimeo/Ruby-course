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

    protected

    attr_writer :instances
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances ||= 0
      self.class.send :instances=, self.class.instances + 1
    end
  end
end
