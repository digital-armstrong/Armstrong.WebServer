# frozen_string_literal: true

module LogBuilder
  def build_html(args = {})
    tag = args[:tag] || 'p'
    html_class = args[:class] || ''
    log_time = args[:time] || DateTime.now
    log_object = args[:log_object]
    log_text = args[:log_text]

    format = {
      full: "[#{log_time}] (#{log_object}) #{log_text}",
      object_text: "(#{log_object}) #{log_text}",
      time_text: "[#{log_time}] #{log_text}",
      text: log_text
    }

    "<#{tag} class=\"#{html_class}\">#{format[args[:format] || :full]}</#{tag}>"
  end
end
