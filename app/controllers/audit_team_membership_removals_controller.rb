class AuditTeamMembershipRemovalsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_audit_team_membership_removal, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @audit_team_membership_removals = AuditTeamMembershipRemoval.all
    respond_with(@audit_team_membership_removals)
  end

  def show
    respond_with(@audit_team_membership_removal)
  end

  def new
    @audit_team_membership_removal = AuditTeamMembershipRemoval.new
    respond_with(@audit_team_membership_removal)
  end

  def edit
  end

  def create
    @audit_team_membership_removal = AuditTeamMembershipRemoval.new(audit_team_membership_removal_params)
    @audit_team_membership_removal.save
    respond_with(@audit_team_membership_removal)
  end

  def update
    @audit_team_membership_removal.update(audit_team_membership_removal_params)
    respond_with(@audit_team_membership_removal)
  end

  def destroy
    @audit_team_membership_removal.destroy
    respond_with(@audit_team_membership_removal)
  end

  private
    def set_audit_team_membership_removal
      @audit_team_membership_removal = AuditTeamMembershipRemoval.find(params[:id])
    end

    def audit_team_membership_removal_params
      params.require(:audit_team_membership_removal).permit(:member_id, :notes, :notified_member, :percentage, :reason)
    end
end
