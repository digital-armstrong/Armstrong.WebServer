class Web::HomeController < ApplicationController
  def index
    @connected_devices = Dir.glob('/dev/ttyUSB*')
    @rates = [1,2,3,4]
    @port = Port.new
    @servers = Server.all
  end

  def new
    @port = Port.new
  end
end
