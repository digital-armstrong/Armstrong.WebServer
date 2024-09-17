# frozen_string_literal: true

module Web
  module Servers
    class PortsController < ApplicationController
      def create
        @port = resource_server.ports.build(port_params)

        if @port.save
          redirect_to root_path, notice: t('.success')
        else
          redirect_to root_path, status: :unprocessable_entity, alert: @comment.errors.full_messages.join('. ')
        end
      end

      private

      def port_params
        params.require(:port).permit(:name, :rate)
      end
    end
  end
end
