class CreateSocialMediaMarketings < ActiveRecord::Migration
  def change
    create_table :social_media_marketings do |t|
      t.references :project, index: true
      t.string :author_facebook_page
      t.string :author_central_account_link
      t.string :website_url
      t.string :twitter
      t.string :pintrest
      t.string :goodreads

      t.timestamps
    end
  end
end
