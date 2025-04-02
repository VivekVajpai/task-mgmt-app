class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy]
  before_action :set_project, only: [:new, :create, :index]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new

    # respond_to do |format|
    #   format.turbo_stream { render partial: "tasks/form", locals: { project: @project, task: @task } }
    #   format.html { render partial: "tasks/form", locals: { project: @project, task: @task } }
    # end
  end

  def create
    @task = @project.tasks.new(task_params)
    
    if @task.save
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
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @project, notice: "Task updated successfully." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.status == "Completed"
      @task.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task.project, notice: "Task deleted successfully." }
      end
    else
      redirect_to @task.project, alert: "Only completed tasks can be deleted."
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
end
