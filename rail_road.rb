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
    else
      user_call
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
    else
      station_action
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
    station = find_station(gets.chomp.capitalize)
    station.each_train do |train|
      puts "#{train.number} #{train.type} " \
                                      "#{train.car_quantity}"
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
    else
      route_action
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
         "поезду\n3. Добавить/Отцепить вагон\n4. Переместить поезд\n5. " \
         "Вывести список вагонов у поезда\n6. Занять места/объем в вагоне"
    input = gets.chomp.to_i
    case input
    when 1
      create_train
    when 2
      set_route
    when 3
      add_car
    when 4
      move_train
    when 5
      car_list
    when 6
      car_action
    else
      train_action
    end
  end

  def create_train
    puts "\nВведите номер поезда:"
    number = gets.chomp
    puts "Выберите тип поезда:\n1. Грузовой\n2. Пассажирский"
    input = gets.chomp.to_i
    case input
    when 1
      trains.push(CargoTrain.new(number))
      puts "Грузовой поезд №#{number} успешно создан."
    when 2
      trains.push(PassengerTrain.new(number))
      puts "Пассажирский поезд №#{number} успешно создан."
    else
      puts 'Тип поезда не был указан.'
    end
  rescue StandardError => e
    puts e.message
  ensure
    user_call
  end

  def set_route
    find_train.set_route(find_route)
    puts 'Маршрут успешно назначен.'
    user_call
  end

  def add_car
    train = find_train
    puts "Выберите действие:\n1. Добавить вагон\n2. Отцепить вагон"
    input = gets.chomp.to_i
    case input
    when 1
      if train.type == :cargo
        puts 'Укажите общий объем вагона:'
        volume = gets.chomp.to_i
        train.add_car(CargoCar.new(train.car_quantity + 1, volume))
      else
        puts 'Укажите количество мест в вагоне:'
        seats = gets.chomp.to_i
        train.add_car(PassengerCar.new(train.car_quantity + 1, seats))
      end
    when 2
      train.remove_car
    else
      add_car
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
    else
      move_train
    end
    user_call
  end

  def car_list
    train = find_train
    if train.type == :cargo
      train.each_car do |car|
        puts "Грузовой вагон №#{car.number}: " \
                                  "свободный объем #{car.free_volume}, " \
                                  "занятый объем #{car.occupied_volume}"
      end
    else
      train.each_car do |car|
        puts "Пассажирский вагон №#{car.number}: " \
                                  "свободные места #{car.free_seats}, " \
                                  "занятые места #{car.occupied_seats}"
      end
    end
    user_call
  end

  def car_action
    train = find_train
    puts 'Введите номер вагона:'
    number = gets.chomp.to_i
    if train.type == :cargo
      puts 'Укажите объем:'
      volume = gets.chomp.to_i
      train.find_car(number).take_volume(volume)
    else
      train.find_car(number).take_seat
    end
    user_call
  end

  def find_train
    puts "\nВведите номер поезда:"
    number = gets.chomp
    trains.find { |train| train.number == number }
  end

  def seed
    trains.clear
    (0..4).each do |i|
      trains.push(CargoTrain.new("0000#{i}"))
    end
    (5..9).each do |i|
      trains.push(PassengerTrain.new("0000#{i}"))
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
