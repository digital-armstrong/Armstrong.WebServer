class Web::ServerController < ApplicationController
  before_actions :set_server, only: %i[show]

  def index
    @servers = Server.all
  end

  def show; end

  def new
    @server = Server.build
  end

  def create
    @server = Server.build(server_params)

    if @server.save
      flesh.now[:success] = t('.sucess')
      redirect_to root_path
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private

  def set_server
    @server = Server.find(params[:id])
  end

  def server_params
    params.require(:server).permit(:port_id, :name)
  end
end
