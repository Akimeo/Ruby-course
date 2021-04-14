# frozen_string_literal: true

class Station
  attr_reader :name, :train_list

  def initialize(name)
    @name = name
    @train_list = []
  end

  def get_train(train)
    train_list.push(train)
  end

  def send_train(train)
    train_list.delete(train)
  end

  def cargo_trains
    train_list.select { |train| train.is_a? CargoTrain }
  end

  def passenger_trains
    train_list.select { |train| train.is_a? PassengerTrain }
  end
end
