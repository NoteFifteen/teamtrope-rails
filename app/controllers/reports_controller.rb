class ReportsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  def high_allocations
    @percent = params[:percent].nil?? 70.0 : params[:percent]
    @team_memberships = Project.high_allocations @percent
  end

  def missing_current_tasks
    @current_tasks = Project.missing_current_tasks
  end

  private
  def booktrope_staff
      redirect_to root_path if !current_user.role? :booktrope_staff
  end
end
