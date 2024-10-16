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
end
