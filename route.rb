# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation
  attr_reader :initial, :terminal, :station_list

  validate :initial, :type, Station
  validate :terminal, :type, Station

  def initialize(initial, terminal)
    @initial = initial
    @terminal = terminal
    validate!
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
