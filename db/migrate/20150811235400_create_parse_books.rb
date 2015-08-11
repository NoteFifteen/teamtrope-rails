class CreateParseBooks < ActiveRecord::Migration
  def change
    create_table :parse_books do |t|
      t.string :object_id
      t.string :apple_id
      t.string :asin
      t.string :author
      t.string :bnid
      t.string :createspace_isbn
      t.string :detail_page_url_nook
      t.string :detail_url_apple
      t.string :detail_url_google_play
      t.string :detail_url
      t.string :epub_isbn
      t.string :epub_isbn_itunes
      t.string :google_play_url
      t.string :hardback_isbn
      t.string :image_url_google_play
      t.string :image_url_nook
      t.string :inclusion_asin
      t.string :kdp_url
      t.string :large_image_apple
      t.string :large_image
      t.string :lightning_source
      t.string :meta_comet_id
      t.string :nook_url
      t.string :paperback_isbn
      t.date :publication_date_amazon
      t.string :publisher
      t.integer :teamtrope_id
      t.integer :teamtrope_project_id
      t.string :title
      t.date :parse_created_at
      t.date :parse_updated_at

      t.timestamps
    end
  end
end
