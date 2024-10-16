# frozen_string_literal: true

require 'uart'
class UartService
  include LogBuilder

  attr_accessor :server, :port, :rate, :package, :retry_limit, :delay_time
  attr_reader   :retry_count

  def initialize(server, args = {})
    @server      = server
    @port        = server.port.name
    @rate        = server.port.rate
    @package     = args[:package] || [0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x45, 0xCA]
    @retry_count = 0
    @retry_limit = args[:retry_limit] || 5
    @delay_time  = args[:delay_time]  || 5
  end

  def port_available?
    Dir.glob(@port).count == 1
  end

  def polling
    loop do
      if port_available?
        UART.open @port do |serial|
          serial.write package.pack('C8')
          response = serial.read(8)
          if @server.may_ready_to_polling? && !@server.polling?
            @server.ready_to_polling!
            @server.start_polling!
          end
          if response.nil?
            html = build_html log_object: server.name, log_text: "Invalid answer for port #{@port}...", class: 'text-warning'
          else
            @retry_count = 0
            html = build_html log_object: server.name, log_text: "Value: #{response[2..6].unpack1('F')}", class: 'text-success'
          end
          ActionCable.server.broadcast('servers_channel', { html:, eventId: 'terminal_update', htmlId: 'terminal' })
        end

      else
        @retry_count += 1
        html = build_html log_object: server.name, log_text: "Port #{@port} is not available... Retry step #{@retry_count}", class: 'text-danger'
        ActionCable.server.broadcast('servers_channel', { html:, eventId: 'terminal_update', htmlId: 'terminal' })

        @server.panic! if @server.may_panic?
      end

      sleep(@delay_time)
    end
  end

  def start_polling
    return nil unless @server.may_start_polling?

    $servers_threads << { # rubocop :disable Style/GlobalVars
      server_id: @server.id,
      server_name: @server.name,
      thread: Thread.new do
        html = build_html log_text: I18n.t('thread.thread_started', server_id: @server.id), class: 'text-success', format: :time_text
        ActionCable.server.broadcast('servers_channel', { html:, eventId: 'terminal_update', htmlId: 'terminal' })

        polling
      end
    }

    @server
  end

  def stop_polling
    detect_and_stop_server_thread
  end

  private

  def detect_and_stop_server_thread
    server_thread = $servers_threads.detect { |t| t[:server_id] == @server.id } # rubocop :disable Style/GlobalVars

    if server_thread.nil?
      Rails.logger.info { "\033[31m#{I18n.t('thread.thread_not_found', server_id: @server.id)}" }

      nil
    else
      server_thread[:thread].kill
      $servers_threads.delete(server_thread) # rubocop :disable Style/GlobalVars

      html = build_html log_text: I18n.t('thread.thread_stopped', server_id: @server.id), class: 'text-success', format: :time_text
      ActionCable.server.broadcast('servers_channel', { html:, eventId: 'terminal_update', htmlId: 'terminal' })

      @server
    end
  end
end
