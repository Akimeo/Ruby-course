# frozen_string_literal: true

class RailRoad
  attr_accessor :cargo_trains, :passenger_trains, :cargo_cars, :passenger_cars,
                :station_names, :stations, :routes

  def initialize
    @cargo_trains = []
    @passenger_trains = []
    @cargo_cars = []
    @passenger_cars = []
    @station_names = []
    @stations = []
    @routes = []
  end

  def seed
    (1..5).each do |i|
      cargo_trains.push(CargoTrain.new(i))
      passenger_trains.push(PassengerTrain.new(i))
    end
    (1..10).each do |_i|
      cargo_cars.push(CargoCar.new)
      passenger_cars.push(PassengerCar.new)
    end
    self.station_names = ['Измайловская', 'Партизанская', 'Семеновская',
                          'Электрозаводская', 'Бауманская', 'Парк Победы',
                          'Минская', 'Ломоносовский проспект', 'Раменки',
                          'Мичуринский проспект', 'Озерная', 'Говорово']
    self.stations = station_names.map { |name| Station.new(name) }
    self.routes = [Route.new(@stations[0], @stations[4]),
                   Route.new(@stations[5], @stations[11])]
    (1..3).each do |i|
      routes[0].add_station(stations[i])
    end
    (6..10).each do |i|
      routes[1].add_station(stations[i])
    end
  end
end
