# encoding: UTF-8

class FaxesController < AuthorizedController
  belongs_to :case

  def new
    render 'show_modal'
  end

  def create
    resource.sender = current_user.object
    resource.save

    resource.send_fax

    flash.notice = 'An fax gesendet...'
    render 'show_flash'
  end
end
