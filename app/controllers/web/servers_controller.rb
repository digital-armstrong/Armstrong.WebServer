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

    if @server.save
      redirect_to root_path, notice: t('.success')
    else
      redirect_to root_path, alert: @server.errors.full_messages.join('. ')
    end
  end

  def start_polling
    server_to_start = @uart.start_polling
    if server_to_start&.may_start_polling?
      server_to_start.start_polling!
      redirect_to root_path
    else
      redirect_to root_path, alert: 'Поток не может быть запущен, потому что уже запущен'
    end
  end

  def stop_polling
    server_to_stop = @uart.stop_polling

    if server_to_stop&.may_ready_to_polling?
      server_to_stop.ready_to_polling!
      redirect_to root_path
    else
      render :index
    end
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
