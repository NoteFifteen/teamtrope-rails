class AddImageRequestListToCoverConcepts < ActiveRecord::Migration
  def change
    change_table :cover_concepts do |t|
      t.json :image_request_list
    end
  end
end
