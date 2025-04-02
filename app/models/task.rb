class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :status, type: String

  belongs_to :project

  validates :title, presence: true
  validates :status, inclusion: { in: ["To do", "In Progress", "Completed"] }

  after_create -> { broadcast_creation() }
  after_update -> { broadcast_updation() }
  after_destroy -> { broadcast_deletion() }

  def broadcast_creation
    Turbo::StreamsChannel.broadcast_append_to("task_crud", 
      target: "tasks",
      partial: "tasks/task",
      locals: {task: self }
    )
  end

  def broadcast_updation
    Turbo::StreamsChannel.broadcast_replace_to("task_crud", 
      target: "id_task_#{self.id.to_s}",
      partial: "tasks/task",
      locals: {task: self }
    )
  end

  def broadcast_deletion
    Turbo::StreamsChannel.broadcast_remove_to("task_crud", 
      target: "id_task_#{self.id.to_s}",
      partial: "tasks/task",
      locals: {task: self }
    )
  end
end
