class ClientsController < ApplicationController
  respond_to :text

  def result_report_index
    client = current_user.object

    attachments = Attachment.where(:object_id => current_user.object.cases)

    last_download = client.settings['result_report.last_download_at']
    attachments = attachments.where("updated_at > ?", last_download) if last_download

    attachment_urls = attachments.collect{ |attachment| download_attachment_url(attachment, :auth_token => current_user.authentication_token) }.join("\r\n")
    client.settings['result_report.last_download_at'] = DateTime.now.utc.to_s(:db)

    render :text => attachment_urls
  end
end
