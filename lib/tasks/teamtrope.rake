namespace :teamtrope do

  desc "Imports DocumentImportQueue into teamtrope rails"
  task queue_import: :environment do
    attachments = Rails.root.join('db', 'seed-data', 'attachments.csv')
    require "csv"
    csv = CSV.parse(File.read(attachments), headers: :first_row)
    csv.each do | row |
      puts "#{row["wp_id"]}\t#{row["fieldname"]}\t#{row["attachment_id"]}\t#{row["url"]}"
      DocumentImportQueue.create!(wp_id: row["wp_id"],
                                  attachment_id: row["attachment_id"],
                                  fieldname: row["fieldname"],
                                  url: row["url"],
                                  status: 0)
    end
  end

  desc "Imports Documents into teamtrope rails"
  task doc_import: :environment do

    limit = ENV["limit"]
    require "net/https"
    require "uri"
    done = false
    count = 0
    while !done

      # fetching the project
      project = Project.where(lock: false, done: false).first

      unless project.nil?

        # locking the project
        project.with_lock do
          project.lock = true
          project.save!
        end

        document_import_queues = DocumentImportQueue.where(wp_id: project.wp_id)

        document_import_queues.each do | document |
          puts "#{document.wp_id} #{document.fieldname} #{document.url}"

          document.status = 10
          document.dyno_id = ENV["dyno_id"]
          document.save

          if document.url !~ /\.[a-zA-Z]+$/
            document.status = 403
            document.error = "OpenURI::HTTPError: 403 Forbidden"
            document.save
            next
          end

          case document.fieldname
          when 'book_manuscript_original'
            project.build_manuscript if project.manuscript.nil?
            project.manuscript.original = prepare_url(document.url, document)
          when 'book_manuscript_edited'
            project.build_manuscript if project.manuscript.nil?
            project.manuscript.edited = prepare_url(document.url, document)
          when 'book_manuscript_proofed'
            project.build_manuscript if project.manuscript.nil?
            project.manuscript.proofed = prepare_url(document.url, document)
          when 'book_layout_upload'
            project.build_layout if project.layout.nil?
            project.layout.layout_upload = prepare_url(document.url, document)
          when 'book_stock_cover_image'
            project.build_cover_concept if project.cover_concept.nil?
            project.cover_concept.stock_cover_image = prepare_url(document.url, document)
          when 'book_cover_concept'
            project.build_cover_concept if project.cover_concept.nil?
            project.cover_concept.cover_concept = prepare_url(document.url, document)
          when 'book_ebook_front_cover'
            project.build_cover_template if project.cover_template.nil?
            project.cover_template.ebook_front_cover = prepare_url(document.url, document)
          when 'book_createspace_cover'
            project.build_cover_template if project.cover_template.nil?
            project.cover_template.createspace_cover = prepare_url(document.url, document)
          when 'book_lightning_source_cover'
            project.build_cover_template if project.cover_template.nil?
            project.cover_template.lightning_source_cover = prepare_url(document.url, document)
          when 'book_alternative_cover_template'
            project.build_cover_template if project.cover_template.nil?
            project.cover_template.alternative_cover = prepare_url(document.url, document)
          when 'book_final_manuscript_pdf'
            project.build_final_manuscript if project.final_manuscript.nil?
            project.final_manuscript.pdf = prepare_url(document.url, document)
          when 'book_final_doc_file'
            project.build_final_manuscript if project.final_manuscript.nil?
            project.final_manuscript.doc = prepare_url(document.url, document)
          when 'book_final_mobi'
            project.build_published_file if project.published_file.nil?
            project.published_file.mobi = prepare_url(document.url, document)
          when 'book_final_epub'
            project.build_published_file if project.published_file.nil?
            project.published_file.epub = prepare_url(document.url, document)
          when 'book_final_pdf'
            project.build_published_file if project.published_file.nil?
            project.published_file.pdf = prepare_url(document.url, document)
          end
        end

        project.lock = false
        project.done = true

        if project.save
          document_import_queues.find_each do | diq |
            next if diq.status == 404
            diq.status = 999
            diq.save
            count = count + 1
          end
        else
          document_import_queues.find_each do | diq |
            diq.error = project.errors.full_messages.to_s
            diq.status = 503
            diq.save
          end
        end
        done = true || (!limit.nil? && count >= limit)
      else
        done = true
      end
      sleep 2.0
    end
  end

  def prepare_url(url, document)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    # If we get a 200 response back from teamtrope, store the URL
    if response.code == '200'
      document.status = 999
      document.save
      uri
    else
      document.status = 404
      document.save
      nil
    end
  end

  desc "Resets documents db"
  task reset: :environment do
    DocumentImportQueue.find_each do | document |
      document.status = 0
      document.dyno_id = nil
      document.error = nil
      document.save
    end

    Project.find_each do | project |
      project.lock = false
      project.done = false
      project.save
    end
  end
end

# wp_id, attachment_id, fieldname, url, status, dyno_id, error
