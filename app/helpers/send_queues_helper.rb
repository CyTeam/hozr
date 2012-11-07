# encoding: UTF-8

module SendQueuesHelper
  def channel_label(channel)
    type = ''
    case channel.to_s
    when 'print'
    when 'hl7'
      type = 'info'
    when 'email', 'overview_email'
      type = 'warning'
    end

    boot_label(channel, type)
  end

  def channel_labels(channels)
    channels.map{|channel| channel_label(channel)}.join(' ').html_safe
  end
end
