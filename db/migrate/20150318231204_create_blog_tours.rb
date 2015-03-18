class CreateBlogTours < ActiveRecord::Migration
  def change
    create_table :blog_tours do |t|
      t.references :project, index: true
      t.float :cost
      t.string :tour_type
      t.string :blog_tour_service
      t.integer :number_of_stops
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
