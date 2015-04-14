# Intended to fire off emails based on actions performed on a Project.
# For the most part this really just passes things along to the ProjectMailer, but
# the listener gives us a little extra separation.
class ProjectMailerListener

  def project_created(project, current_user)
    ProjectMailer.project_created(project, current_user)
  end

  def project_status_update(project, current_user)
    ProjectMailer.project_status_update(project, current_user)
  end

  def edit_control_numbers(project, current_user)
    ProjectMailer.edit_control_numbers(project, current_user)
  end

  def accepted_team_member(project, current_user, params)
    ProjectMailer.accepted_team_member(project, current_user, params)
  end

  def received_1099_form(project, current_user)
    ProjectMailer.received_1099_form(project, current_user)
  end

  def rev_allocation_change(project, current_user, effective_date)
    ProjectMailer.rev_allocation_change(project, current_user, effective_date)
  end

  def remove_team_member(project, current_user, params)
    ProjectMailer.remove_team_member(project, current_user, params)
  end

  def original_manuscript_uploaded(project, current_user)
    ProjectMailer.original_manuscript_uploaded(project, current_user)
  end

  def submit_edited_manuscript(project, current_user)
    ProjectMailer.submit_edited_manuscript(project, current_user)
  end

  def proofed_manuscript(project, current_user, params)
    ProjectMailer.proofed_manuscript(project, current_user, params)
  end

  def marketing_release_date(project, current_user, release_date)
    ProjectMailer.marketing_release_date(project, current_user, release_date)
  end


end