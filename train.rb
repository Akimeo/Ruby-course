# frozen_string_literal: true

class Train
  include ProducerName
  include InstanceCounter
  attr_reader :number, :type, :car_list
  attr_accessor :speed

  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  @@train_list = []

  def self.find(number)
    @@train_list.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    validate!
    @speed = 0
    @car_list = []
    @@train_list.push(self)
    register_instance
  end

  def validate!
    raise 'Номер поезда должен быть строкой' unless number.is_a? String
    raise 'Номер поезда имеет некорректный формат' if number !~ NUMBER_FORMAT
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def stop
    self.speed = 0
  end

  def add_car(car)
    car_list.push(car) if speed.zero? && car.type == type
  end

  def remove_car
    car_list.pop if speed.zero?
  end

  def car_quantity
    car_list.size
  end

  def set_route(route)
    self.route = route
    self.route_pos = 0
    current_station.get_train(self)
  end

  def move_next
    return unless next_station

    current_station.send_train(self)
    self.route_pos += 1
    current_station.get_train(self)
  end

  def move_previous
    return unless previous_station

    current_station.send_train(self)
    self.route_pos -= 1
    current_station.get_train(self)
  end

  def next_station
    return if current_station == route.terminal

    route.full_list[route_pos + 1]
  end

  def current_station
    route.full_list[route_pos]
  end

  def previous_station
    return if current_station == route.initial

    route.full_list[route_pos - 1]
  end

  def each_car(&block)
    car_list.each(&block)
  end

  def find_car(number)
    car_list.find { |car| car.number == number }
  end

  # Пользователь не должен вручную менять маршрут или положение поезда

  protected

  attr_accessor :route, :route_pos
end
