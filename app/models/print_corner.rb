class PrintCorner < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  OrderTypes = [
      ['author_copies', 'I want to order author copies.'],
      ['creative_member', 'I want to order copies as a creative team member.'],
      ['marketing', 'I want to order copies for marketing purposes.']
  ]

end
