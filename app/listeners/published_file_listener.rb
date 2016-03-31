# app/listeners/team_memberships_listener.rb
class PublishedFileListener
  def published_file_modified(published_file)
    MonthlyPublishedBook.generate_monthly_report
  end
end
