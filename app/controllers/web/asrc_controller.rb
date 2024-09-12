class Web::AsrcController < ApplicationController
  def index

  end
  def start_polling
    PollingJob.perform_later
  end

  def stop_polling
    @uart.stop_polling
  end
end
