# frozen_string_literal: true

class CargoTrain < Train
  def add_car(car)
    super if car.is_a? CargoCar
  end
end
