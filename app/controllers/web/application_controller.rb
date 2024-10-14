# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  def connected_devices
    @connected_devices = Dir.glob('/dev/ttyUSB*')
  end

  def set_baud_rates
    @rates = [
      1200, 2400, 4800, 9600, 19_200, 38_400, 57_600, 115_200
    ]
  end
end
