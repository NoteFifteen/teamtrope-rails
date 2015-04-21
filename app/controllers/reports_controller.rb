class ReportsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  def high_allocations
    @team_memberships = Project.high_allocations
  end

  private
  def booktrope_staff
      redirect_to root_path if !current_user.role? :booktrope_staff
  end
end
