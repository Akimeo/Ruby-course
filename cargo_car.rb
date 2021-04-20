# frozen_string_literal: true

class CargoCar < Car
  attr_reader :volume, :occupied_volume

  def initialize(number, volume)
    super(number)
    @type = :cargo
    @volume = volume
    @occupied_volume = 0
  end

  def take_volume(amount)
    return if occupied_volume + amount > volume

    self.occupied_volume += amount
  end

  def free_volume
    volume - occupied_volume
  end

  private

  attr_writer :occupied_volume
end
