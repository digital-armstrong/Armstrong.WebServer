# frozen_string_literal: true

class Web::Servers::ApplicationController < Web::ApplicationController
  def resource_server
    @resource_server ||= Server.find(params[:server_id])
  end
end
