class Web::AsrcController < ApplicationController
  def index
  end

  def start_polling(server_id)
    uart = UartService.new(params[:port])
    uart.start_polling(server_id)
  end

  def stop_polling
    UartService.stop_polling
  end
end
