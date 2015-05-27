class ProductionExpense < ActiveRecord::Base
  belongs_to :project

  COSTS = ['setup_fee_ebook_only', 'setup_fee_ebook_print', 'revision_resubmission_fee', 'proof_copy', 'donation']
  ADDITIONAL_COSTS = [
    ['setup_fee_ebook_only','Setup fee - ebook only' ],
    ['setup_fee_ebook_print', 'Setup fee - ebook & print'],
    ['revision_resubmission_fee', 'Revision & Resubmission Fee'],
    ['proof_copy', 'Proof copy'],
    ['donation', 'Donation']
  ]

  def additional_costs=(cost)
    self.additional_cost_mask = ([cost] & COSTS).map { |t| 2**COSTS.index(t) }.sum
  end

  def additional_costs
    COSTS.reject { |t| ((additional_cost_mask || 0) & 2**COSTS.index(t)).zero? }
  end

end
