# encoding: utf-8'
class OrderFormsController < AuthorizedController
  # CRUD
  def create
    create! {new_order_form_path}
  end

  # AJAX functions
  def head_image
    @order_form = OrderForm.find(params[:id])
    @image_type = params[:type] || session[:order_form_image_type]

    session[:order_form_image_type] = @image_type

    render 'head_image'
  end

  def show
    @order_form = OrderForm.find(params[:id])
  end

  # Scan
  def scan
    scanner = current_tenant.settings['scanning.order_form']
    Dir.chdir(OrderForm::SCANNER_SPOOL_PATH) do
      system('scanimage', '--device', scanner, '--scan-area', 'A4', '--mode', 'Gray', '--batch', '--resolution', '200')
    end

    OrderForm.post_scanning_processing

    redirect_to new_case_assignments_path
  end

  # Image
  def download
    order_form = OrderForm.find(params[:id])
    if type = params[:type]
      order_form.send(:file_state).create_magick_version_if_needed(type.to_sym)
    end

    path = order_form.file(type)
    send_file path
  end

  def inline
    order_form = OrderForm.find(params[:id])
    if type = params[:type]
      order_form.send(:file_state).create_magick_version_if_needed(type.to_sym)
    end

    path = order_form.file(type)
    send_file path, :disposition => 'inline'
  end
end
