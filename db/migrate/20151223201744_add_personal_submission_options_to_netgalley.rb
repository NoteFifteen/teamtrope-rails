# TTR-259 - Allow the user to elect to pay for submission
class AddPersonalSubmissionOptionsToNetgalley < ActiveRecord::Migration
  def change
    add_column :netgalley_submissions, :personal_submission, :boolean
    add_column :netgalley_submissions, :paypal_email, :string
  end
end
