class TasksController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    params[:order] ||= 'due_on'
    @tasks = Task.paginate(:page => params['page'], :per_page => 100)
  end

  def schedule
    list
    render :action => 'list'
  end
  
  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    case params[:task_type][:name]
    when 'HpvTask'
      @task = HpvTask.new(params[:task])
    when 'P16Task'
      @task = P16Task.new(params[:task])
    when 'CentrifugeTask'
      @task = CentrifugeTask.new(params[:task])
    end

    if @task.save
      flash[:notice] = 'Task was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = 'Task was successfully updated.'
      redirect_to :action => 'show', :id => @task
    else
      render :action => 'edit'
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
