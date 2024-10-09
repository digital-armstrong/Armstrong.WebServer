# frozen_string_literal: true

class Web::ServersController < Web::ApplicationController
  before_action :set_server, only: %i[start_polling stop_polling]
  before_action :set_uart, only: %i[start_polling stop_polling]

  def show; end

  def new
    @server = Server.new
  end

  def create
    @server = Server.build(server_params)
    @server.save
  end

  def start_polling
    server_to_start = @uart.start_polling
    return unless server_to_start&.may_start_polling?

    server_to_start.start_polling!
  end

  def stop_polling
    server_to_stop = @uart.stop_polling

    return unless server_to_stop&.may_ready_to_polling?

    server_to_stop.ready_to_polling!
  end

  private

  def set_server
    @server = Server.find(params[:id])
  end

  def server_params
    params.require(:server).permit(:name, port_attributes: %i[name rate])
  end

  def set_uart
    @uart = UartService.new(@server)
  end
end
