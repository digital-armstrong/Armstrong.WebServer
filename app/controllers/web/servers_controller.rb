# frozen_string_literal: true

class Web::ServersController < Web::ApplicationController
  before_action :set_server, only: %i[start_polling stop_polling destroy edit update]
  before_action :set_uart, only: %i[start_polling stop_polling]
  before_action :connected_devices, only: %i[edit]
  before_action :set_baud_rates, only: %i[edit]
  def show; end

  def new
    @server = Server.new
  end

  def edit
    unless @server.idle? # rubocop:disable Style/GuardClause
      redirect_to root_path
    end
  end

  def create
    @server = Server.build(server_params)
    @server.save
  end

  def update
    if @server.update(server_params)
      redirect_to root_path
    else
      Rails.logger.debug('server update error')
    end
  end

  def destroy
    return unless @server.idle?

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
