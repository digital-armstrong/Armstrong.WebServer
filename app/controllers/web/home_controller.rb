# frozen_string_literal: true

class Web::HomeController < Web::ApplicationController
  before_action :connected_devices, only: %i[index]
  before_action :set_baud_rates, only: %i[index]

  def index
    @port = Port.new
    @server = Server.new
    @servers = Server.all
    @port = @server.build_port
  end

  def new
    @server = Server.new
  end

  private

  def connected_devices
    @connected_devices = Dir.glob('/dev/ttyUSB*')
  end

  def set_baud_rates
    @rates = [
      1200, 2400, 4800, 9600, 19_200, 38_400, 57_600, 115_200
    ]
  end
end
