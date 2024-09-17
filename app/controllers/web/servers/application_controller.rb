# frozen_string_literal: true

module Web
  module Servers
    class ApplicationController < ApplicationController
      def resource_server
        @resource_server ||= Server.find(params[:server_id])
      end
    end
  end
end
