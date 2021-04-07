# frozen_string_literal: true

class Station
  attr_accessor :train_list

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
    output = []
    train_list.each { |train| output.push(train) if train.type == 'cargo' }
    output
  end

  def passenger_trains
    output = []
    train_list.each { |train| output.push(train) if train.type == 'passenger' }
    output
  end
end

class Route
  attr_reader :initial, :terminal, :station_list

  def initialize(initial, terminal)
    @initial = initial
    @terminal = terminal
    @station_list = []
  end

  def add_station(station)
    station_list.push(station)
  end

  def remove_station(station)
    station_list.delete(station)
  end

  def print_stations
    puts initial
    station_list.each { |station| puts station }
    puts terminal
  end
end

class Train
  attr_accessor :speed, :car_quantity, :route, :route_pos, :route_length

  attr_reader :type

  def initialize(number, type, car_quantity)
    @number = number
    @type = type
    @car_quantity = car_quantity
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def add_car
    self.car_quantity += 1 if speed.zero?
  end

  def remove_car
    self.car_quantity = [self.car_quantity - 1, 0].max if speed.zero?
  end

  def set_route(route)
    self.route = route
    self.route_pos = 1
    self.route_length = self.route.station_list.length + 2
  end

  def move_next
    self.route_pos = [route_pos + 1, route_length].min
  end

  def move_previous
    self.route_pos = [route_pos - 1, 1].max
  end

  def next_station
    return nil if route_pos == route_length
    return route.terminal if route_pos == route_length - 1

    route.station_list[route_pos - 1]
  end

  def current_station
    return route.initial if route_pos == 1
    return route.terminal if route_pos == route_length

    route.station_list[route_pos - 2]
  end

  def previous_station
    return nil if route_pos == 1
    return route.initial if route_pos == 2

    route.station_list[route_pos - 3]
  end
end
