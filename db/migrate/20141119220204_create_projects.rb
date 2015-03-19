class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|

      t.string :stock_image_request_link
      t.text :layout_notes
      t.boolean :previously_published
      t.string :prev_publisher_and_date
      t.text :cover_concept_notes
      t.float :proofed_word_count
      t.string :teamroom_link
      t.datetime :publication_date
      t.datetime :marketing_release_date
      t.string :paperback_cover_type
      t.string :age_range
      t.text :search_terms
      t.string :bisac_code_3
      t.string :bisac_code_2
      t.string :bisac_code_1
      t.float :ebook_price
      t.float :print_price
      t.string :blurb_one_line
      t.text :endorsements
      t.text :author_bio
      t.text :blurb_description
      t.string :title
      t.string :final_title
      t.datetime :cover_art_approval_date
      t.datetime :layout_approved_date
      t.float :final_page_count
      t.boolean :use_pen_name_on_title
      t.boolean :use_pen_name_for_copyright
      t.string :exact_name_on_copyright
      t.string :pen_name
      t.text :special_text_treatment
      t.boolean :has_sub_chapters
      t.string :layout_style_choice
      t.boolean :has_index
      t.boolean :non_standard_size
      t.boolean :has_internal_illustrations
      t.boolean :color_interior
      t.boolean :childrens_book    
      t.datetime :edit_complete_date
      
      #docs
      t.attachment :manuscript_proofed
      t.attachment :manuscript_edited
      t.attachment :manuscript_original
      t.attachment :final_doc_file
      
      #pdfs
      t.attachment :final_manuscript_pdf
      t.attachment :final_pdf
			t.attachment :layout_upload
      
      #images
      t.attachment :cover_concept
      t.attachment :stock_cover_image
          

      t.timestamps
    end
  end
end
