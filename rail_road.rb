# frozen_string_literal: true

class RailRoad
  def greeting
    puts 'Добро пожаловать! Эта программа позволяет создавать абстрактные ' \
         'станции, маршруты и поезда, а также управлять ими. Пожалуйста, ' \
         'следуйте указаниям на экране.'
    user_call
  end

  #   Логика программы подразумевает, что пользователь будет обращаться
  #   к методам в определенной последовательности.

  private

  attr_accessor :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def user_call
    puts "\nВыберите категорию:\n1. Станции\n2. Маршруты\n3. Поезда\n4. " \
         "Тестовый набор\n0. Завершить выполнение программы"
    input = gets.chomp.to_i
    case input
    when 1
      station_action
    when 2
      route_action
    when 3
      train_action
    when 4
      seed
    when 0
      nil
    end
  end

  def station_action
    puts "\nВыберите действие:\n1. Создать станцию\n2. Вывести список " \
         "всех станций\n3. Вывести список поездов на станции"
    input = gets.chomp.to_i
    case input
    when 1
      create_station
    when 2
      print_stations
    when 3
      print_trains
    when 0
      nil
    end
  end

  def create_station
    puts "\nВведите название станции:"
    name = gets.chomp.capitalize
    stations.push(Station.new(name))
    puts "Станция с названием \"#{name}\" успешно создана."
    user_call
  end

  def print_stations
    puts "\nСтанции:"
    stations.each { |station| puts "  #{station.name}" }
    user_call
  end

  def print_trains
    puts "\nВведите название станции:"
    name = gets.chomp.capitalize
    puts "Поезда на станции \"#{name}\":\n  Грузовые:\n"
    find_station(name).cargo_trains.each do |train|
      puts "    Поезд №#{train.number}"
    end
    puts '  Пассажирские:'
    find_station(name).passenger_trains.each do |train|
      puts "    Поезд №#{train.number}"
    end
    user_call
  end

  def find_station(name)
    stations.find { |station| station.name == name }
  end

  def route_action
    puts "\nВыберите действие:\n1. Создать маршрут\n2. Добавить станцию в " \
         "маршрут\n3. Удалить станцию из маршрута"
    input = gets.chomp.to_i
    case input
    when 1
      create_route
    when 2
      add_station
    when 3
      remove_station
    end
  end

  def create_route
    puts "\nВведите названия начальной и конечной станций маршрута:"
    names = gets.chomp.split.map(&:capitalize)
    routes.push(Route.new(find_station(names[0]), find_station(names[1])))
    puts "Маршрут \"#{names[0]}-#{names[1]}\" успешно создан."
    user_call
  end

  def add_station
    puts "\nВведите название станции, которую вы хотите добавить в маршрут:"
    name = gets.chomp.capitalize
    find_route.add_station(find_station(name))
    puts "Станция \"#{name}\" успешно добавлена в маршрут."
    user_call
  end

  def remove_station
    puts "\nВведите название станции, которую вы хотите удалить из маршрута:"
    name = gets.chomp.capitalize
    find_route.remove_station(find_station(name))
    puts "Станция \"#{name}\" успешно удалена из маршрута."
    user_call
  end

  def find_route
    puts 'Введите названия начальной и конечной станций маршрута:'
    names = gets.chomp.split.map(&:capitalize)
    routes.find do |route|
      route.initial == find_station(names[0]) &&
        route.terminal == find_station(names[1])
    end
  end

  def train_action
    puts "\nВыберите действие:\n1. Создать поезд\n2. Назначить маршрут " \
         "поезду\n3. Добавить/Отцепить вагон\n4. Переместить поезд"
    input = gets.chomp.to_i
    case input
    when 1
      create_train
    when 2
      set_route
    when 3
      car_action
    when 4
      move_train
    end
  end

  def create_train
    puts "\nВведите номер поезда:"
    number = gets.chomp.to_i
    puts "Выберите тип поезда:\n1. Грузовой\n2. Пассажирский"
    input = gets.chomp.to_i
    case input
    when 1
      trains.push(CargoTrain.new(number))
    when 2
      trains.push(PassengerTrain.new(number))
    end
    puts "Поезд №#{number} успешно создан."
    user_call
  end

  def set_route
    find_train.set_route(find_route)
    puts 'Маршрут успешно назначен.'
    user_call
  end

  def car_action
    train = find_train
    puts "Выберите действие:\n1. Добавить вагон\n2. Отцепить вагон"
    input = gets.chomp.to_i
    case input
    when 1
      if train.type == :cargo
        train.add_car(CargoCar.new)
      else
        train.add_car(PassengerCar.new)
      end
    when 2
      train.remove_car
    end
    puts "У поезда №#{train.number} теперь #{train.car_quantity} вагон(а/ов)."
    user_call
  end

  def move_train
    train = find_train
    puts "Выберите направление:\n1. Вперед\n2. Назад"
    input = gets.chomp.to_i
    case input
    when 1
      if train.move_next
        puts "Поезд №#{train.number} успешно перемещен со станции " \
             "\"#{train.previous_station.name}\" на станцию " \
             "\"#{train.current_station.name}\"."
      else
        puts "Поезд №#{train.number} не перемещен, так как находится " \
             'на конечной станции.'
      end
    when 2
      if train.move_previous
        puts "Поезд №#{train.number} успешно перемещен со станции " \
             "\"#{train.next_station.name}\" на станцию " \
             "\"#{train.current_station.name}\"."
      else
        puts "Поезд №#{train.number} не перемещен, так как находится " \
             'на начальной станции.'
      end
    end
    user_call
  end

  def find_train
    puts "\nВведите номер поезда:"
    number = gets.chomp.to_i
    trains.find { |train| train.number == number }
  end

  def seed
    trains.clear
    (1..5).each do |i|
      trains.push(CargoTrain.new(i))
    end
    (6..10).each do |i|
      trains.push(PassengerTrain.new(i))
    end
    station_names = ['Измайловская', 'Партизанская', 'Семеновская',
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
    puts 'Тестовый набор успешно создан.'
    user_call
  end
end
