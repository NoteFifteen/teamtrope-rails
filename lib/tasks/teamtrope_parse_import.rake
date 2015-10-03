namespace :teamtrope do

  desc 'Imports records from the Parse Books object into the parse_books table'
  task import_parse_books: :environment do

    processed_total = 0

    query = Parse::Query.new('Book')
    query.limit = 1000
    query.get.each do |b|
      puts "Processing #{b['objectId']}  - #{b['title']}"
      rec = ParseBooks.where(object_id: b['objectId']).first_or_create

      # Note - Postgres doesn't handled mixed case column names very well, and you have to properly quote them
      # so it's advised to stick with lowercase.  I've added an underscore before each camel-cased word and
      # lowercased the value to make it easy to read.

      rec.apple_id                = b['appleId']
      rec.asin                    = b['asin']
      rec.author                  = b['author']
      rec.bnid                    = b['bnid']
      rec.createspace_isbn        = b['createspaceIsbn']
      rec.detail_page_url_nook    = b['detailPageUrlNook']
      rec.detail_url              = b['detail_url']
      rec.epub_isbn               = b['epubIsbn']
      rec.epub_isbn_itunes        = b['epubIsbnItunes']
      rec.google_play_url         = b['googlePlayUrl']
      rec.hardback_isbn           = b['hardbackIsbn']
      rec.image_url_google_play   = b['imageUrlGooglePlay']
      rec.image_url_nook          = b['imageUrlNook']
      rec.inclusion_asin          = b['inclusionASIN']
      rec.kdp_url                 = b['kdpUrl']
      rec.large_image_apple       = b['largeImageApple']
      rec.large_image             = b['large_image']
      rec.lightning_source        = b['lightningSource']
      rec.meta_comet_id           = b['metaCometId']
      rec.nook_url                = b['nookUrl']
      rec.paperback_isbn          = b['paperbackIsbn']
      rec.publication_date_amazon = b['publicationDateAmazon']
      rec.publisher               = b['publisher']
      rec.teamtrope_id            = b['teamtropeId']
      rec.teamtrope_project_id    = b['teamtropeProjectId']
      rec.title                   = b['title']
      rec.parse_created_at        = b['createdAt']
      rec.parse_updated_at        = b['updatedAt']
      rec.save

      processed_total += 1
    end

    puts "Processed #{processed_total} records."
  end

  desc 'Imports records from the Parse Books object into the parse_books table'
  task import_sales_report_csv: :environment do

    raise "You must specify the CSV file to import.\n\t ex: rake teamtrope:import_sales_report report_file=report_2015_08_01.csv \n" if !ENV['report_file']
    raise "Cannot locate #{ENV['report_file']}!" unless File.exist?(ENV['report_file'])

    report_processor = Booktrope::SalesReportProcessor.new
    report_processor.process_report_file(ENV['report_file'])

  end

  desc "Updates bnid in control_numbers based on what's in Parse"
  task backfill_bnid_from_parse: :environment do
    query = Parse::Query.new('Book')
    query.limit = 1000
    query.get.each do |b|

      if ! b['bnid'].nil?
        cn = ControlNumber.find_by_parse_id(b['objectId'])

        if ! cn.nil?
          puts "Updating project #{cn.project_id}"
          cn.bnid = b['bnid']
          cn.save
        end

      end

    end
  end

end
