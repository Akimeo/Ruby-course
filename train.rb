# frozen_string_literal: true

class Train
  attr_accessor :speed, :car_list, :route, :route_pos

  def initialize(number)
    @number = number
    @speed = 0
    @car_list = []
  end

  def stop
    self.speed = 0
  end

  def add_car(car)
    car_list.push(car) if speed.zero?
  end

  def remove_car(car)
    car_list.delete(car) if speed.zero?
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
end