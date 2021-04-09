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
    train_list.select { |train| train.type == 'cargo' }
  end

  def passenger_trains
    train_list.select { |train| train.type == 'passenger' }
  end
end

class Route
  attr_reader :initial, :terminal, :station_list, :train_list

  def initialize(initial, terminal)
    @initial = Station.new(initial)
    @terminal = Station.new(terminal)
    @station_list = []
    @train_list = []
  end

  def add_station(station)
    station_list.push(station)
  end

  def remove_station(station)
    station_list.delete(station)
  end

  def add_train(train)
    train_list.push(train)
  end

  def remove_train(train)
    train_list.delete(train)
  end

  def full_list
    [initial] + station_list + [terminal]
  end

  def print_stations
    full_list.each { |station| puts station }
  end
end

class Train
  attr_accessor :speed, :car_quantity, :route, :route_pos

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
    self.route.add_train(self)
    self.route.initial.get_train(self)
    self.route_pos = 0
  end

  def move_next
    return nil if route.full_list[route_pos] == route.terminal

    route.full_list[route_pos].send_train(self)
    self.route_pos += 1
    route.full_list[route_pos].get_train(self)
  end

  def move_previous
    return nil if route.full_list[route_pos] == route.initial

    route.full_list[route_pos].send_train(self)
    self.route_pos -= 1
    route.full_list[route_pos].get_train(self)
  end

  def next_station
    return nil if route.full_list[route_pos] == route.terminal

    route.full_list[route_pos + 1]
  end

  def current_station
    route.full_list[route_pos]
  end

  def previous_station
    return nil if route_pos.zero?

    route.full_list[route_pos - 1]
  end
end
