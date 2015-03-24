class Project < ActiveRecord::Base

	include PublicActivity::Model

	belongs_to :project_type
	belongs_to :imprint
	
  has_many :audit_team_membership_removals
  has_many :blog_tours, dependent: :destroy
  has_many :book_genres, foreign_key: :project_id, dependent: :destroy
  has_one  :control_number, dependent: :destroy
  has_one  :cover_concept, dependent: :destroy
  has_one  :cover_template, dependent: :destroy
  has_many :current_tasks
	has_many :genres, through: :book_genres, source: :genre
  has_one  :kdp_select_enrollment, dependent: :destroy
  has_one  :layout, dependent: :destroy
  has_many :marketing_expenses, dependent: :destroy
  has_many :media_kits, dependent: :destroy
  has_many :members, through: :team_memberships, source: :member
  has_many :price_change_promotions, dependent: :destroy
  has_one  :publication_fact_sheet, dependent: :destroy
  has_one  :published_file, dependent: :destroy
  has_many :roles, through: :team_memberships, source: :role
  has_many :status_updates, dependent: :destroy
  has_many :team_memberships

  #TODO: we might not need to allow destroy via the project form for associations that
  # are only written by form. (media_kits, price_change_promotions, published_file, status_update)
  accepts_nested_attributes_for :audit_team_membership_removals, reject_if: :all_blank, allow_destroy: false
  accepts_nested_attributes_for :blog_tours, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :cover_template, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :cover_concept, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :kdp_select_enrollment, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :layout, reject_if: :all_blank, allow_destroy: false
  accepts_nested_attributes_for :media_kits, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :marketing_expenses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :price_change_promotions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :publication_fact_sheet, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :published_file, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :status_updates, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :team_memberships, reject_if: :all_blank, allow_destroy: true

  # Not an actual column, but used in the ProjectsController
  attr_accessor :cover_art_approval_decision

  has_attached_file :manuscript_original
  has_attached_file :manuscript_edited
  has_attached_file :manuscript_proofed
  has_attached_file :final_pdf
  has_attached_file :final_doc_file
  has_attached_file :final_manuscript_pdf

  validates_attachment :manuscript_original, 
  	*Constants::DefaultContentTypeDocumentParams

  validates_attachment :manuscript_edited,
		*Constants::DefaultContentTypeDocumentParams
  	
  validates_attachment :manuscript_proofed,
  	*Constants::DefaultContentTypeDocumentParams
  	
  validates_attachment :final_pdf,
  	*Constants::DefaultContentTypePdfParams
  	
  validates_attachment :final_doc_file,
  	*Constants::DefaultContentTypeDocumentParams

	# mainly used for debugging purposes.
	# Returns the current_task for a particular workflow
	def current_task_for_workflow(workflow)
		current_tasks.joins(:task).includes(:task).where("tasks.workflow_id = ? ", 
							Workflow.where(name: workflow).first).first
	end

  def team_complete?
		required_roles = project_type.required_roles.ids
		team_members = team_memberships.map { |member| member.role_id }
		
		required_roles.all? {| required_role | team_members.include? required_role }
	end

  def available_roles
    required_roles = project_type.required_roles.ids
    team_members = team_memberships.map { |member| member.role_id }
    available = required_roles - team_members

    project_type.roles.where(id: available)
  end

	def is_team_member?(user)
		members.ids.include?(user.id)
	end
	
	def is_my_editor?(user)
		team_memberships.where(member_id: user.id, role_id: Role.where(name: "Editor")).count > 0
	end
	
	def team_roles(user)
		team_memberships.where(member_id: user.id).map { | membership | membership.role }
	end
	
	def team_members_with_roles
		team_memberships.select("roles.name").joins(:role).includes(:role, 
		:member).order("roles.name").group_by(&:member_id).map do | key, memberships |
				{ :member => memberships.first.member, :roles => memberships.map {|membership| 
				membership.role.name }.join(", ")  
				}
		end	
	end

  def team_allocations
    team = []
    project_type.required_roles.each do |rr|

      role = self.send(rr.role.normalized_name.pluralize).first
      member_name = (role.nil?) ? '' : role.member.name
      member_percentage = (role.nil?) ? 0 : self.send(rr.role.normalized_name.pluralize).first.percentage

      team << { :role_name => rr.role.name,
                :member_name => member_name,
                :suggested_percentage => rr.suggested_percent,
                :allocated_percentage => member_percentage
             }
    end
    return team
  end

  def members_available_for_removal
    team_memberships.reject{|s| s.new_record? }
                    .reject{|s| s.role.normalized_name == 'author' }
                    .map { |member| {
                      membership_id: member.id,
                      member_name: member.member.name + ' (' + member.role.name + ')'
                    }
     }
  end

  def self.provide_methods_for(role)
		Project.class_eval %Q{	
			def has_#{role.downcase.gsub(/ /, "_")}?
				team_memberships.where(role_id: Role.where(name: "#{role}")).count > 0
			end
		}
		Project.class_eval %Q{
			def #{role.downcase.gsub(/ /, "_").pluralize}
				team_memberships.where(role_id: Role.where(name: "#{role}"))
			end
		}
	end
	
	Role.all.map{ |role| role.name  }.each do | role |
		provide_methods_for(role)
	end

end
