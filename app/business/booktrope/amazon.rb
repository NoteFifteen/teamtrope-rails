module Booktrope
  class Amazon
    require 'amazon/ecs'

    $book_hash = {}

    # use the amazon class defined in amazon/ecs
    ::Amazon::Ecs.options = {
      associate_tag: Figaro.env.amazon_ecs_associate_tag,
      AWS_access_key_id: Figaro.env.amazon_ecs_access_key_id,
      AWS_secret_key: Figaro.env.amazon_ecs_secret_key
    }

    # looks up the books on amazon
    def Amazon.look_up_books(book_list)

      Amazon.prepare_hash book_list
      valid_list = Amazon.get_valid_book_list book_list

      Amazon.look_up_books_by_interval valid_list

      $book_hash
    end

    private

    # groups up the books by an interval and invokes the look up by set function
    def Amazon.look_up_books_by_interval(valid_list)
      book_count = valid_list.count
      current_index = 0
      count_interval = 10

      done = false

      while !done
        book_set = valid_list.slice(current_index, count_interval)

        asin_book_set = book_set.map { | book | book['asin'] }

        puts "looking up #{current_index} to #{count_interval} of #{valid_list.count}"

        Amazon.look_up_set_by_asin(asin_book_set.join(","))
        sleep 1.0

        current_index = current_index + count_interval
        done = true if current_index >= book_count
      end
    end

    def Amazon.look_up_set_by_asin(book_set)

      # use the amazon/ecs class not the one we namespaced to Booktrope
      results = ::Amazon::Ecs.item_lookup(book_set,:response_group => 'ItemAttributes,SalesRank,Images')

      #todo handle errors
      results.items.each do | item |
        asin = item.get('ASIN')

        # If we ever want to update the local information we have on file these
        # are the fields to use.

        # detailPageUrl = item.get('DetailPageURL')
        # salesRank = item.get('SalesRank')
        # largeImageUrl = item.get('LargeImage/URL')
        # author = item.get('ItemAttributes/Author')
        # manufacturer = item.get('ItemAttributes/Manufacturer')
        # publication_date = Parse::Date.new(item.get('ItemAttributes/PublicationDate'))
        # title = item.get('ItemAttributes/Title')

        if $book_hash.has_key? asin
          book_wrapper = $book_hash[asin]
          book_wrapper[:status] = true
        else
          #puts "ASIN NOT FOUND IN HASH. That's Unpossible!"
        end
      end
    end

    # prepare the book_hash which is a hash that maps the asin to
    # a hash that contains the parse book record and a status flag.
    # the status flag is true if the book was found for sale.
    def Amazon.prepare_hash(book_list)
      book_list.each do | book |
        unless book['asin'].nil? || book['asin'].strip == ''
          $book_hash[book['asin'].strip] = { book: book, status: false }
        else
          puts "Skipped no ASIN for #{book['objectId']}"
        end
      end
    end

    # used to return the list of valid books to look up on Amazon.
    def Amazon.get_valid_book_list(book_list)
      valid_list = []
      book_list.each do | book |
        unless book['asin'].nil? || book['asin'].strip == ''
          valid_list.push book
        end
      end
      valid_list
    end
  end
end
