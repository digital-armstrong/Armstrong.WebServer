# frozen_string_literal: true

module ApplicationHelper
  def send_notification(message, alert_type)
    rendered_notification = ApplicationController.renderer.render(
      partial: 'web/shared/notification',
      locals: { message:,
                alert_type: }
    )
    ActionCable.server.broadcast('notification_channel', { html: rendered_notification })
  end
end
