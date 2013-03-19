class CaseCopyTosController < AuthorizedController
  belongs_to :case

  def new
    render 'show_modal'
  end

  def edit
    render 'show_modal'
  end
end
