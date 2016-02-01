namespace :teamtrope do

  desc "Syncs the amazon publication date with teamtrope"
  task sync_publication_date_with_amazon: :environment do
    require 'csv'

    book_list = Booktrope::ParseWrapper.get_books(exists: ["publicationDateAmazon"])

    results = []

    book_list.each do | book |


      parse_object_id = book["objectId"]
      publication_date_time = book["publicationDateAmazon"].value


      result_hash = {
        updated: "No",
        parse_id: parse_object_id,
        asin: book["asin"],
        amazon_publication_date: publication_date_time.strftime("%Y/%m/%d"),
        project_title: book["title"],
        former_publication_date: nil,
        reason: nil
      }

      results << result_hash

      control_number = ControlNumber.where(parse_id: parse_object_id).includes(project: [:published_file]).first

      if control_number.nil?
        result_hash[:reason] = "parse_id not found in db"
        next
      end

      project = control_number.project

      if project.nil?
        result_hash[:reason] = "project not found"
        next
      end

      result_hash[:project_title] = project.book_title

      published_file = project.published_file

      # create a published file if none exists
      if published_file.nil?
        project.create_published_file(publication_date: publication_date_time)
        published_file = project.published_file
        result_hash[:reason] = "published file not found so we created a new one"
      end

      if published_file.publication_date.nil?
        published_file.publication_date = publication_date_time
        published_file.save
        result_hash[:updated] = "Yes"
      else
        result_hash[:former_publication_date] = published_file.publication_date
        result_hash[:reason] = "publication_date already exists #{result_hash[:former_publication_date]}"
      end

    end

    # amazon publication date update csv header
    amzn_pub_date_header = {
      updated: "Updated",
      parse_id: "Parse Id",
      asin: "ASIN",
      project_id: "Project ID",
      project: "Project",
      amazon_publication_date: "New Date",
      former_publication_date: "Data Before Change",
      reason: "Notes"
     }

    csv_string = CSV.generate do |csv|
      csv << amzn_pub_date_header.values
      results.each do | result_hash |
        row = []

        row.push result_hash[:updated]
        row.push result_hash[:parse_id]
        row.push result_hash[:asin]
        row.push result_hash[:project_id]
        row.push result_hash[:project_title]
        row.push result_hash[:amazon_publication_date]
        row.push result_hash[:former_publication_date]
        row.push result_hash[:reason]

        csv << row
      end
    end

    ReportMailer.amazon_publication_date_sync(csv_string)

  end



  desc "Validates permanent price changes to ensure they are entered into the queue correctly as a price increase or a price drop."
  task validate_permanent_price_drops: :environment do

    # get all permanent price drops with from now unitl next year.
    PriceChangePromotion.with_type("permanent_price_drop")
      .where(start_date: Date.today..1.year.since, validated: false)
      .each do | pcp |

        puts pcp.project.control_number.parse_id

        # fetch the scoreboard record on parse.
        amazon_score_board_record = Booktrope::ParseWrapper.get_amazon_score_board(pcp.project.control_number.parse_id)
        validated = true
        unless amazon_score_board_record.nil?
          if amazon_score_board_record["got_price"]

            # If the price_promotion is greater than the current price, we need to
            # set is_price_increase on the parse record to true.
            if pcp.price_promotion >= amazon_score_board_record["kindle_price"]
              parse_ids = pcp.parse_ids["start_ids"].split(",")

              # loop through the parse_ids fetch and update each one.
              parse_ids.each do | parse_id |
                puts parse_id
                Booktrope::ParseWrapper.request do
                  price_change_queue_item = Parse::Query.new(Booktrope::ParseWrapper::PriceChangeQueue).tap do | q |
                    q.eq("objectId", parse_id)
                  end.get.first

                  price_change_queue_item["isPriceIncrease"] = true
                  price_change_queue_item.save
                end
                sleep 1.0
              end
            end
          else
            validated = false # don't validate if the scoreboard doesn't have a price.
          end
        else
          validated = false # don't validate if there was no scoreboard found.
        end
        pcp.update_attributes(validated: validated) if validated
    end

  end
end
