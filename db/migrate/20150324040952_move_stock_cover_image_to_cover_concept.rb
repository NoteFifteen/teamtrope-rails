class MoveStockCoverImageToCoverConcept < ActiveRecord::Migration
  # Move Stock Cover Image attachment to the CoverConcept model
  # Note - This will not move data and is not safe after production!
  def change
    remove_attachment :projects, :stock_cover_image

    change_table :cover_concepts do |t|
      t.attachment :stock_cover_image
    end
  end
end
