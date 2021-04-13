# frozen_string_literal: true

class PassengerTrain < Train
  def add_car(car)
    super if car.is_a? PassengerCar
  end
end
