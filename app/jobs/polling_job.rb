require './lib/uart_service'
class PollingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    uart = UartService.new('/dev/ttyUSB0')
    uart.start_polling
  end
end
