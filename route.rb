# frozen_string_literal: true

class Route
  include InstanceCounter
  attr_reader :initial, :terminal, :station_list

  def initialize(initial, terminal)
    @initial = initial
    @terminal = terminal
    @station_list = []
    register_instance
  end

  def add_station(station)
    station_list.push(station)
  end

  def remove_station(station)
    station_list.delete(station)
  end

  def full_list
    [initial] + station_list + [terminal]
  end

  def print_stations
    full_list.each { |station| puts station }
  end
end
