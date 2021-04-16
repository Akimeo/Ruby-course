# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    protected

    attr_writer :instances
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.send :instances=, 0 if self.class.instances.nil?
      self.class.send :instances=, self.class.instances + 1
    end
  end
end
