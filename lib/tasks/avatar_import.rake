namespace :avatar_import do

  desc "Import the avatars from a CSV file."
  task import: :environment do
    require 'csv.rb'

    CSV.foreach(Rails.root.join('db','seed-data', 'wp-avatars.csv').to_s, :headers => :first_row, :header_converters => :symbol) do | rec |
      id = rec[:id].lstrip
      avatar_url = rec[:avatar_url].lstrip

      user = User.find_by_uid(id)

      if user.nil?
        puts "Cannot find user #{id}"
      else
        puts "Importing avatar from url #{avatar_url} for user #{id}"
        user.profile.import_avatar_from_url(avatar_url)
      end
    end
  end
end
