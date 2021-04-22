# frozen_string_literal: true

class Station
  include InstanceCounter
  include Accessors
  include Validation
  attr_reader :train_list

  attr_accessor_with_history :name

  validate :name, :type, String
  validate :name, :presence

  @@station_list = []

  def self.all
    @@station_list
  end

  def initialize(name)
    @name = name
    validate!
    @train_list = []
    @@station_list.push(self)
    register_instance
  end

  def get_train(train)
    train_list.push(train)
  end

  def send_train(train)
    train_list.delete(train)
  end

  def cargo_trains
    train_list.select { |train| train.type == :cargo }
  end

  def passenger_trains
    train_list.select { |train| train.type == :passenger }
  end

  def each_train(&block)
    train_list.each(&block)
  end
end
