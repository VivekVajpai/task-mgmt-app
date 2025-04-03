class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy]
  before_action :set_project, only: [:new, :create, :index]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    
    if @task.save
      get_tasks_count
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @project, notice: "Task created successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("task_form", partial: "tasks/form", locals: { project: @project, task: @task }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # binding.pry
    respond_to do |format|
      # format.turbo_stream
      format.html
    end
  end

  def update
    if @task.update(task_params)
      get_tasks_count
      respond_to do |format|
        format.turbo_stream
        # format.html { redirect_to @project, notice: "Task updated successfully." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    get_tasks_count
    respond_to do |format|
      format.turbo_stream
      # format.html { redirect_to @task.project, notice: "Task deleted successfully." }
    end
  end

  private

  def set_task
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :project_id)
  end

  def get_tasks_count
    @tasks = @project.tasks
    @total_project_tasks = @tasks.count
    @to_do_tasks_count = @tasks.where(status: "To do").count
    @in_progress_tasks_count = @tasks.where(status: "In Progress").count
    @completed_tasks_count = @tasks.where(status: "Completed").count
    @progress_bar = ((@completed_tasks_count.to_f/@total_project_tasks)*100).round(2)
  end
end
