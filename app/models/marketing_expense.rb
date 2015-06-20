class MarketingExpense < ActiveRecord::Base
  belongs_to :project

 EXPENSE_TYPES =
  [
    'Blog Tour',
    'Newsletter Ad - Discounted Price',
    'Newsletter Ad - List Price',
    'Contest Giveaway',
    'Facebook Ad',
    'Other - Please Describe below'
  ]

  SERVICE_PROVIDERS =
  [
    'BookBub',
    'eReader News Today',
    'Bargain eBook Hunter',
    'Kindle Books and Tips d/b/a/ Gagler Enterprises',
    'eBookFling',
    'eReader Buddy',
    'Other - Please specify below'
  ]


  def service_provider=(provider)
    providers = []
    providers.push provider unless provider.class == Array
    self.service_provider_mask = (providers & SERVICE_PROVIDERS).map { |r| 2**SERVICE_PROVIDERS.index(r) }.sum
  end

  def service_provider
    SERVICE_PROVIDERS.reject { |r| ((service_provider_mask || 0) & 2**SERVICE_PROVIDERS.index(r)).zero? }
  end


  def expense_type=(expense)
    expenses = []
    expenses.push expense unless expense.class == Array
    self.type_mask = (expenses & EXPENSE_TYPES).map { |r| 2**EXPENSE_TYPES.index(r) }.sum
  end

  def expense_type
    EXPENSE_TYPES.reject { |r| ((type_mask || 0) & 2**EXPENSE_TYPES.index(r)).zero? }
  end

end
