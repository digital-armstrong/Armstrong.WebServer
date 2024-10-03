# frozen_string_literal: true

require 'uart'
class UartService
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

    print_info
  end

  def print_info
    Rails.logger.debug "\n\n================================"
    Rails.logger.debug { "Port:\t\t#{@port}" }
    Rails.logger.debug { "Retry Limit:\t#{@retry_limit}" }
    Rails.logger.debug { "Package:\t#{@package}" }
    Rails.logger.debug { "Delay Time:\t#{@delay_time}" }
    Rails.logger.debug "================================\n\n"
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
            ActionCable.server.broadcast('servers_channel', { html: "[#{DateTime.now.strftime('%F %T')}]\t(server##{@server.id})<span class='text-warning'>\tInvalid answer for port #{@port}...</span>", dom_id: "server_#{@server.id}", event_id: 2 })
          else
            @retry_count = 0
            ActionCable.server.broadcast('servers_channel', { html: "<p class='text-success'>Time: #{DateTime.now.strftime('%F %T')}\t\tValue: #{response[2..6].unpack1('F')}</p>", dom_id: "server_#{@server.id}", event_id: 2 })
          end
        end

      else
        @retry_count += 1
        ActionCable.server.broadcast('servers_channel', { html: "<p class='text-danger'>Port #{@port} is not available... Retry step #{@retry_count}</p>", dom_id: "server_#{@server.id}", event_id: 2 })

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
        ActionCable.server.broadcast('servers_channel', { html: "<p class='text-success'>#{I18n.t('thread.thread_started', server_id: @server.id)}</p>", dom_id: "server_#{@server.id}", event_id: 2 })

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

      ActionCable.server.broadcast('servers_channel', { html: "#{I18n.t('thread.thread_stopped', server_id: @server.id)}", dom_id: "server_#{@server.id}", event_id: 2 })
      @server
    end
  end
end
