class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    @tasks = @project.tasks
    @total_project_tasks = @tasks.count
    @to_do_tasks_count = @tasks.where(status: "To do").count
    @in_progress_tasks_count = @tasks.where(status: "In Progress").count
    @completed_tasks_count = @tasks.where(status: "Completed").count
    @progress_bar = ((@completed_tasks_count.to_f/@total_project_tasks)*100).round(2)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.append("projects", partial: "projects/project", locals: { project: @project }) }
        format.html { redirect_to projects_path, notice: "Project was successfully created." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("project_form", partial: "projects/form", locals: { project: @project }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project deleted successfully."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
