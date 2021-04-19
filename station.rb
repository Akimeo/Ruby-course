# frozen_string_literal: true

class Station
  include InstanceCounter
  attr_reader :name, :train_list

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

  def validate!
    raise 'Название станции должно быть строкой' unless name.is_a? String
    raise 'Название станции не может быть пустой строкой' if name == ''
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
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
end
