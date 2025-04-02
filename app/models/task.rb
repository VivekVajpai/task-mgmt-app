class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :status, type: String

  belongs_to :project

  validates :title, presence: true
  validates :status, inclusion: { in: ["To do", "In Progress", "Completed"] }
end
