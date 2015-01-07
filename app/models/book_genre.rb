class BookGenre < ActiveRecord::Base
  belongs_to :project
  belongs_to :genre
end
