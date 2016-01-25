namespace :teamtrope do

  desc "Populates ProjectGridTableRow"
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
