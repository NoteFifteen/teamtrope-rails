class Role < ActiveRecord::Base
  has_many :team_memberships
  has_many :users, through: :team_memberships, source: :member

  has_many :task_performers, foreign_key: :role_id, dependent: :destroy
  has_many :tasks, through: :task_performers, source: :task

  has_many :required_roles, dependent: :destroy
  has_many :project_types, through: :required_roles, source: :role

  default_scope -> { order("name asc") }

  # Returns percentage recommended allocation
  def suggested_percent
    self.required_roles.first.suggested_percent
  end

  def needs_agreement?
    needs_agreement
  end

  def normalized_name
    name.downcase.gsub(/ /, '_')
  end
end
