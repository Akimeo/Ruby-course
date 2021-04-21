# frozen_string_literal: true

class Car
  include ProducerName
  attr_reader :type, :number

  def initialize(number)
    @number = number
  end
end
