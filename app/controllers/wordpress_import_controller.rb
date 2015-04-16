class WordpressImportController < ApplicationController

  def import
  end

  def upload
    require 'nokogiri'
    # parsing the uploaded xml file
    doc = Nokogiri::XML((params.permit(:upload_file)[:upload_file]).read)

    # getting the list of items
    items = doc.xpath("//item")

    puts items.count

    # looping through the projects
    items.each_with_index do | item, index |
      puts "#{index}\t#{item.xpath("./wp:post_id").text}\t#{item.xpath("./title").text}"

      # create the project
      project = Project.new(title: item.xpath("./title").text, project_type_id: 1,  **prepare_project_fields(item))
      # build ControlNumber
      project.build_control_number(**prepare_control_number_fields(item))
      # build PublicationFactSheet
      project.build_publication_fact_sheet(**prepare_publication_fact_sheet_fields(item))
      # build CoverConcept
      project.build_cover_concept(**prepare_cover_concept_fields(item))

      #print 'production: '
      #puts fetch_field_value(item,'book_pcr_step')
      #print 'design: '
      #puts fetch_field_value(item,'book_pcr_step_cover_design')
      #print 'marketing: '
      #puts fetch_field_value(item, 'book_pcr_step_mkt_info')


      project.save
    end
  end

  private
  def deserialize_php_array(serialized_data)
    results = Array.new
    serialized_data.scan(/i:([0-9])+;s:([0-9]+):\"(.+?)\";/).each do | match |
      results.push match[2]
    end
    results
  end

  def prepare_project_fields(project_meta)
    {
      childrens_book: fetch_field_value(project_meta, 'book_childrens_book'),
      color_interior: fetch_field_value(project_meta, 'book_color_interior'),
      edit_complete_date: fetch_field_value(project_meta, 'book_edit_complete_date'),
      final_title: fetch_field_value(project_meta, 'book_final_title'),
      has_index: fetch_field_value(project_meta, 'book_has_index'),
      has_internal_illustrations: fetch_field_value(project_meta, 'book_has_internal_illustrations'),
      has_sub_chapters: fetch_field_value(project_meta, 'book_has_sub-chapters'),
      marketing_release_date: fetch_field_value(project_meta, 'book_marketing_release_date'),
      non_standard_size: fetch_field_value(project_meta, 'book_non-standard_size'),
      prev_publisher_and_date: fetch_field_value(project_meta, 'book_prev_publisher_published'),
      previously_published: fetch_field_value(project_meta, 'book_previously_published'),
      proofed_word_count: fetch_field_value(project_meta, 'book_proofed_word_count'),
      publication_date: fetch_field_value(project_meta, 'book_publication_date'),
      special_text_treatment: fetch_field_value(project_meta, 'book_special_text_treatment'),
      stock_image_request_link: fetch_field_value(project_meta, 'book_stock_image_request_link'),
      teamroom_link: fetch_field_value(project_meta, 'book_teamroom_link'),
    }
  end

  def prepare_control_number_fields(project_meta)
    {
      apple_id: fetch_field_value(project_meta, 'book_apple_id'),
      asin: fetch_field_value(project_meta, 'book_asin'),
      epub_isbn: fetch_field_value(project_meta, 'book_ebook_isbn'),
      hardback_isbn: fetch_field_value(project_meta, 'book_hardback_isbn'),
      paperback_isbn: fetch_field_value(project_meta, 'book_isbn'),
      parse_id: fetch_field_value(project_meta, 'book_parse_id'),
    }
  end

  def prepare_cover_concept_fields(project_meta)
    {
      cover_art_approval_date: fetch_field_value(project_meta, 'book_cover_art_approval_date'),
      #cover_concept: book_cover_concept,
      cover_concept_notes: fetch_field_value(project_meta, 'book_cover_concept_notes'),
      #stock_cover_image: fetch_field_value(project_meta, 'book_stock_cover_image'),
    }
  end

  def prepare_publication_fact_sheet_fields(project_meta)
    {
      age_range: fetch_field_value(project_meta, 'book_age_range'),
      author_bio: fetch_field_value(project_meta, 'book_author_bio'),
      bisac_code_one: fetch_field_value(project_meta, 'book_bisac_code_1'),
      bisac_code_two: fetch_field_value(project_meta, 'book_bisac_code_2'),
      bisac_code_three: fetch_field_value(project_meta, 'book_bisac_code_3'),
      description: fetch_field_value(project_meta, 'book_blurb_description'),
      ebook_price: fetch_field_value(project_meta, 'book_ebook_price'),
      endorsements: fetch_field_value(project_meta, 'book_endorsements'),
      one_line_blurb: fetch_field_value(project_meta, 'book_blurb_one_line'),
      paperback_cover_type: fetch_field_value(project_meta, 'book_paperback_cover_type'),
      print_price: fetch_field_value(project_meta, 'book_print_price'),
      search_terms: fetch_field_value(project_meta, 'book_search_terms'),
      series_name: fetch_field_value(project_meta, 'book_series_name'),
      series_number: fetch_field_value(project_meta, 'book_series_number')
    }
  end

  def prepare_layout_fields(project_meta)
    {
      exact_name_on_copyright: fetch_field_value(project_meta, 'book_exact_name_on_copyright'),
      final_page_count: fetch_field_value(project_meta, 'book_final_page_count'),
      layout_approved_date: fetch_field_value(project_meta, 'book_layout_approved_date'),
      layout_notes: fetch_field_value(project_meta, 'book_layout_notes'),
      layout_style_choice: fetch_field_value(project_meta, 'book_layout_style_choice'),
      #layout_upload: book_layout_upload
      pen_name: fetch_field_value(project_meta, 'book_pen_name'),
      use_pen_name_for_copyright: fetch_field_value(project_meta, 'book_use_pen_name_for_copyright'),
      use_pen_name_on_title: fetch_field_value(project_meta, 'book_use_pen_name_on_title'),
    }
  end

  def fetch_field_value(item, key)
    item.xpath("./wp:postmeta/wp:meta_key[text() = '#{key}']/following-sibling::wp:meta_value/text()").text
  end

end

# Project.where("projects.id NOT IN (?)", [1,2]).delete_all

      # looping through the fields
      #item.xpath("./wp:postmeta").each_with_index do | postmeta, j |
      #  meta_key = postmeta.xpath("./wp:meta_key").text.strip
      #  next if meta_key.start_with? "_"

      #  meta_value = postmeta.xpath("./wp:meta_value").text.strip
      #  data_string = ""

      #  if meta_value =~ /a:[0-9]+:{i:([0-9]+);s:([0-9]+):\"(.*?)\";}/
      #    data_string = "\t#{j}\t#{meta_key}\n"
      #    deserialize_php_array(meta_value).each do | item |
      #      data_string << "\t\t\t#{item}\n"
      #    end
      #  else
      #    data_string = "\t#{j}\t#{meta_key}\t#{meta_value}"
      #  end
      #  puts data_string
      #end
