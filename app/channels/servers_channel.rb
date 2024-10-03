class ServersChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'servers_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast('servers_channel', data)
  end
end
