class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String

  has_many :tasks, dependent: :destroy
  validates :name, presence: true
end
