namespace :teamtrope do

  desc "Populates ProjectGridTableRow"
  task enqueue_ppd_validation_task: :environment do

    # get all permanent price drops with from now unitl next year.
    PriceChangePromotion.with_type("permanent_price_drop")
      .where(start_date: Date.today..1.year.since)
      .each do | pcp |

        puts pcp.project.control_number.parse_id

        # fetch the scoreboard record on parse.
        amazon_score_board_record = Booktrope::ParseWrapper.get_amazon_score_board(pcp.project.control_number.parse_id)

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

                  price_change_queue_item["is_price_increase"] = true
                  price_change_queue_item.save
                end
                sleep 1.0
              end
            end
          else
            # We might want to generate a report or add a new column to the db
            # that indicates that a permanent price drop has had it's price confirmed.
            # After updating the increase and confirming it's correct we could
            # mark it true and add it to the query:
            # PriceChangePromotion.with_type("permanent_price_drop")
            #      .where(start_date: Date.today..1.year.since, validated: false)
            # puts "no price"
          end
        else
        end
    end



  end
end
