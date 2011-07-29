class OrderFormsController < ApplicationController
  helper :doctors
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @order_forms = OrderForm.find(:all, :conditions => "created_at >= '2007-01-15'")
  end

  def show
    @order_form = OrderForm.find(params[:id])
  end

  def new
    @order_form = OrderForm.new
  end

  def create
    @order_form = OrderForm.new(params[:order_form])
    a_case = Case.new
    a_case.save
    @order_form.a_case = a_case
    
    if @order_form.save
      flash[:notice] = 'OrderForm was successfully created.'
      redirect_to :controller => 'cases', :action => 'first_entry_queue'
    else
      render :action => 'new'
    end
  end

  def edit
    @order_form = OrderForm.find(params[:id])
  end

  def update
    @order_form = OrderForm.find(params[:id])
    if @order_form.update_attributes(params[:order_form])
      flash[:notice] = 'OrderForm was successfully updated.'
      redirect_to :action => 'show', :id => @order_form
    else
      render :action => 'edit'
    end
  end

  def destroy
    OrderForm.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  # AJAX functions
  def head_big
    @order_form = OrderForm.find(params[:id])
    session[:header_image_type] = :head_big
    render :inline => '<%= (link_to image_tag(url_for_image_column(@order_form, "file", :head_big)), url_for_file_column(@order_form, "file")) unless @order_form.nil? %>'
  end

  def head_small
    @order_form = OrderForm.find(params[:id])
    session[:header_image_type] = :head
    render :inline => '<%= (link_to image_tag(url_for_image_column(@order_form, "file", :head)), url_for_file_column(@order_form, "file")) unless @order_form.nil? %>'
  end
end
