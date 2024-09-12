class Web::AsrcController < ApplicationController
  require './lib/uart_service'
  def start_polling
    @uart = UartService.new('/dev/ttyUSB0')
    @uart.start_polling
  end
end
