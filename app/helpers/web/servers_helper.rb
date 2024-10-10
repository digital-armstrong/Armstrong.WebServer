# frozen_string_literal: true

module Web::ServersHelper
  def select_color(state)
    color = {
      'polling' => 'success',
      'panic' => 'danger',
      'idle' => 'light text-dark'
    }

    color[state]
  end
end
