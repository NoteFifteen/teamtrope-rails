class ReportsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  def high_allocations
    @percent = params[:percent].nil?? 70.0 : params[:percent]
    @projects = Project.high_allocations @percent
  end

  def missing_current_tasks
    @projects = Project.missing_current_tasks
  end

end
