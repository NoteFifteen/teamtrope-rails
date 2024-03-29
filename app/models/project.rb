class Project < ActiveRecord::Base

  include ApplicationHelper
  include PublicActivity::Model


  # constants
  SceneChangeOptions = [
    'All scene changes are indicated with 3 asterisks (***) ',
    'All scene changes are indicated with extra line spaces',
    'All scene changes are indicated with an image',
    'Manuscript contains a combination of different types of scene breaks/POV changes and uses multiple methods (e.g. asterisks for scene breaks, extra line space for POV changes)',
  ]

  # friendly_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :project_type
  belongs_to :imprint

  delegate :name, to: :imprint, allow_nil: true, prefix: "imprint"

  has_one  :approve_blurb, dependent: :destroy
  has_many :artwork_rights_requests, dependent: :destroy
  has_many :audit_team_membership_removals
  has_many :blog_tours, dependent: :destroy
  has_many :book_genres, foreign_key: :project_id, dependent: :destroy
  has_many :bookbub_submissions, dependent: :destroy
  has_one  :control_number, dependent: :destroy
  has_one  :cover_concept, dependent: :destroy
  has_one  :cover_template, dependent: :destroy
  has_many :current_tasks, dependent: :destroy
  has_one  :draft_blurb, dependent: :destroy
  has_one  :ebook_only_incentive, dependent: :destroy
  has_one  :final_manuscript, dependent: :destroy
  has_many :genres, through: :book_genres, source: :genre
  has_many :imported_contracts, dependent: :destroy
  has_one  :kdp_select_enrollment, dependent: :destroy
  has_one  :layout, dependent: :destroy
  has_one  :man_dev, dependent: :destroy
  has_many :marketing_expenses, dependent: :destroy
  has_one  :manuscript, dependent: :destroy
  has_one  :media_kit, dependent: :destroy
  has_many :members, through: :team_memberships, source: :member
  has_one  :netgalley_submission, dependent: :destroy
  has_one  :prefunk_enrollment, dependent: :destroy
  has_many :price_change_promotions, dependent: :destroy
  has_many :print_corners, dependent: :destroy
  has_many :production_expenses, dependent: :destroy
  has_one  :project_grid_table_row, dependent: :destroy
  has_one  :publication_fact_sheet, dependent: :destroy
  has_one  :published_file, dependent: :destroy
  has_one  :rights_back_request, dependent: :destroy
  has_many :roles, through: :team_memberships, source: :role
  has_one  :social_media_marketing, dependent: :destroy
  has_many :team_memberships, inverse_of: :project

  alias :pfs :publication_fact_sheet

  #TODO: we might not need to allow destroy via the project form for associations that
  # are only written by form. (media_kits, price_change_promotions, published_file)
  accepts_nested_attributes_for :approve_blurb, reject_if: :all_blank, allow_destroy: false
  accepts_nested_attributes_for :artwork_rights_requests, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :audit_team_membership_removals, reject_if: :all_blank, allow_destroy: false
  accepts_nested_attributes_for :blog_tours, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :book_genres, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :bookbub_submissions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :control_number, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :cover_template, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :cover_concept, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :draft_blurb, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :ebook_only_incentive, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :final_manuscript, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :imported_contracts, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :kdp_select_enrollment, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :layout, reject_if: :all_blank, allow_destroy: false
  accepts_nested_attributes_for :man_dev, reject_if: :all_blank, allow_destroy: false
  accepts_nested_attributes_for :media_kit, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :marketing_expenses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :manuscript, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :netgalley_submission, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :prefunk_enrollment,reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :price_change_promotions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :print_corners, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :production_expenses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :publication_fact_sheet, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :published_file, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :rights_back_request, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :social_media_marketing, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :team_memberships, reject_if: :all_blank, allow_destroy: true

  # scope that returns projects with an allocation higher than percent
  scope :high_allocations, -> (percent) {
    joins(:team_memberships)
    .select("projects.*, sum(team_memberships.percentage) as sum_percentage")
    .group("projects.id")
    .having("sum(team_memberships.percentage) > ?", percent)
    .includes(:team_memberships => [:member, :role])
  }

  # scope that returns projects that do not have enough current tasks (must have 3)
  scope :missing_current_tasks, -> () {
    joins(:current_tasks)
    .select("projects.*, count(projects.id) as task_count")
    .group("projects.id")
    .having("count(projects.id) < 3")
    .includes(:current_tasks => :task)
  }

  # scope that returns projects whose current task are task_name
  scope :with_task, -> (task_name) {
    joins(:current_tasks)
    .includes(:team_memberships => [:member, :role])
    .order(title: :asc)
    .where("current_tasks.task_id = ?", Task.where(name: task_name).first.try(:id))
  }

  scope :with_no_contracts, -> () {
    where.not(id: Project.joins(team_memberships: :hellosign_document).distinct.ids)
  }

  scope :archived, -> () {
    where(archived: true)
  }

  scope :not_archived, -> () {
    where(archived: false)
  }

  BOOK_TYPES = [
    ['ebook only', 'ebook_only'],
    ['ebook and print', 'ebook_and_print']
  ]

  # gets the title of the book depending on if it has a final_title or not.
  # final_title overrides title
  def book_title
    unless final_title.nil? || final_title.strip == ""
      final_title
    else
      title
    end
  end

  def book_type_pretty
    book_type.nil?? "" : BOOK_TYPES.map{ |n| n.reverse }.to_h[book_type]
  end

  # Not an actual column, but used in the ProjectsController
  attr_accessor :blurb_approval_decision

  # Not an actual column, but used in the ProjectsController
  attr_accessor :cover_art_approval_decision

  # Not an actual column, but used in the ProjectsController
  attr_accessor :man_dev_decision

  def table_of_contents?
    table_of_contents
  end

  # mainly used for debugging purposes.
  # Returns the current_task for a particular workflow
  def current_task_for_workflow(workflow)
    current_tasks.joins(:task).includes(:task).where("tasks.workflow_id = ? ",
              Workflow.where(name: workflow).first).first
  end

  # Necessary to set up the initial records for current_tasks for the workflow
  # based on the project type.
  def create_workflow_tasks
    if self.current_tasks.empty?
      self.project_type.workflows.each { |t| self.current_tasks.build(task_id: t.root_task_id) }
      self.save
    end
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

    project_type.roles.all

  end

  #return true if there are no outstanding unsigned documents for this project.
  # def valid_member? user
  #     HellosignDocument
  #       .where(team_membership_id: team_memberships.where(member: user).ids, is_complete: false)
  #       .where.not(cancelled: true, pending_cancellation: true)
  #       .count <= 0
  # end

  def unsigned_contracts user
      HellosignDocument
        .where(team_membership_id: team_memberships.where(member: user).ids, is_complete: false)
        .where.not(cancelled: true, pending_cancellation: true)
  end

  def contracts
    HellosignDocument
      .joins(team_membership: :role)
      .includes(team_membership: [:role, :member])
      .where("team_memberships.project_id = ?", id)
  end

  def is_team_member?(user)
    members.ids.include?(user.id)
  end

  def team_roles(user)
    team_memberships.includes(:role).where(member_id: user.id).map { | membership | membership.role }
  end

  def team_members
    team_memberships.includes(:member).group_by(&:member_id).map{|key, memberships|
      { id: memberships.first.member.id, name: memberships.first.member.name }
    }
  end

  def team_members_with_roles
    team_memberships.select("roles.name").joins(:role).includes(:role,
    :member, member: [:profile]).order("roles.name").group_by(&:member_id).map do | key, memberships |
        { :member => memberships.first.member, :roles => memberships.map {|membership|
        membership.role.name }.join(", ")
        }
    end
  end

  def team_members_with_roles_and_pcts
    team_memberships.select("roles.name").joins(:role).includes(:role,
    :member, member: [:profile]).order("roles.name").group_by(&:member_id).map do | key, memberships |
        { :member => memberships.first.member, :role_pcts => memberships.map {|membership|
        { role: membership.role.name, pct: membership.percentage } }
        }
    end
  end

  def total_team_percent_allocation
    team_memberships.sum(:percentage)
  end

  # Returns a suggested per-member allocation for a given role
  # (taking into account the possibility of zero or multiple members in that role)
  def suggested_allocation(role)
    count = self.send(role.name.normalize.pluralize).count
    count = [count, 1].max
    role.suggested_percent / count
  end

  def suggested_allocation_by_name(role_name)
    suggested_allocation(Role.find_by(name: role_name))
  end

  # Returns a list of all roles and each member in those roles (there may be multiples) if they've been assigned
  def team_allocations
    team = []
    project_type.required_roles.includes(:role).each do |rr|

      role = self.send(rr.role.name.normalize.pluralize)

      # We're excluding the optional roles here, so they don't show in the table if they haven't been added.
      # A role is optional if and only if suggested_percent is 0
      # If there's more than one member in a role, then divide suggested_percent by number of members
      if role.count == 0 && rr.suggested_percent > 0.0
        team << { :role_name => rr.role.name,
                  :member_name => '',
                  :allocated_percentage => 0
        }
      else
        role.each do |mr|

          team << { :role_name => mr.role.name,
                    :member_name => mr.member.name,
                    :allocated_percentage => mr.percentage
          }
        end
      end


    end
    return team
  end

  def members_available_for_removal
    team_memberships.includes(:role, :member).reject{|s| s.new_record? }
                    .reject{|s| s.role.name.normalize == 'author' unless self.authors.count > 1}
                    .map { |member| {
                      membership_id: member.id,
                      member_name: member.member.name + ' (' + member.role.name + ')'
                    }
     }
  end

  def remaining_task_ids
    remaining_tasks = []
    current_tasks.includes(:task).each do | ct |
      task = ct.task
      while(task.next_id != nil)
        remaining_tasks << task.id
        task = task.next_task
      end
    end
    remaining_tasks.uniq
  end

  def self.generate_master_meta_export(project_grid_table_rows, page_type = :csv)
    master_metadata_rows = []
    project_grid_table_rows.each do | pgtr |
      master_metadata_rows << ProjectGridTableRow.generate_master_metadata_export_hash(pgtr, page_type)
    end
    master_metadata_rows
  end

  def self.generate_master_meta_export_csv(master_metadata_rows)
    require 'csv'
    csv_string = CSV.generate do | csv |
      csv << Constants::MasterMetadataHeaderHash.values
      master_metadata_rows.each do | master_metadata_row_hash |
        csv << master_metadata_row_hash.values
      end
    end
    csv_string
  end

  def self.generate_scribd_export(project_grid_table_rows, page_type = :csv)
    scribd_data_rows = []
    project_grid_table_rows.each do | pgtr |

      scribd_data_rows.push(pgtr.generate_scribd_export_hash(page_type))
    end
    scribd_data_rows
  end

  def self.generate_scribd_export_csv(scribd_data_rows)
    require 'csv'
    csv_string = CSV.generate do | csv |
      csv << Constants::ScribdCsvHeaderHash.values
      scribd_data_rows.each do | scribd_data_row_hash |
        csv << scribd_data_row_hash.values
      end
    end
    csv_string
  end

  def self.provide_methods_for(role)
    Project.class_eval %Q{
      def has_#{role.downcase.gsub(/ /, "_")}?
        team_memberships.where(role_id: Role.where(name: "#{role}")).count > 0
      end
    }
    Project.class_eval %Q{
      def #{role.downcase.gsub(/ /, "_").pluralize}
        team_memberships.includes(:member, :role).where(role_id: Role.where(name: "#{role}"))
      end
    }
  end

  Role.all.map{ |role| role.name  }.each do | role |
    provide_methods_for(role)
  end

end
