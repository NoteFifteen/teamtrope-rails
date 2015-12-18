class AddBookManagerToNetgalleySubmissionAndEbookOnlyIncentive < ActiveRecord::Migration
  def change
    add_column :netgalley_submissions, :book_manager, :string
    add_column :ebook_only_incentives, :book_manager, :string
  end
end
