# frozen_string_literal: true

class Web::ServersController < Web::ApplicationController
  before_action :set_server, only: %i[start_polling stop_polling destroy]
  before_action :set_uart, only: %i[start_polling stop_polling]

  def show; end

  def new
    @server = Server.new
  end

  def create
    @server = Server.build(server_params)
    @server.save
  end

  def destroy
    @server.destroy
  end

  def start_polling
    server = @uart.start_polling
    return unless server&.may_start_polling?

    server.start_polling!
  end

  def stop_polling
    server = @uart.stop_polling

    return unless server&.may_ready_to_polling?

    server.ready_to_polling!
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
