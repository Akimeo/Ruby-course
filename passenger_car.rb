# frozen_string_literal: true

class PassengerCar < Car
  attr_reader :seats, :occupied_seats

  def initialize(number, seats)
    super(number)
    @type = :passenger
    @seats = seats
    @occupied_seats = 0
  end

  def take_seat
    return if occupied_seats == seats

    self.occupied_seats += 1
  end

  def free_seats
    seats - occupied_seats
  end

  private

  attr_writer :occupied_seats
end
