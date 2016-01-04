module Booktrope
  class Apple
    $apple_book_hash = {}
    $isbn_book_hash = {}
    ITUNES_LOOKUP_URL = "http://itunes.apple.com/lookup"
    INTERVAL = 10

    # This function is the main driver for the apple report.
    # returns a hash with two hashes in it.
    # the apple_id hash is the apple_book_hash which is the results of books looked up via apple_id
    # the isbn hash is the isbn_book_hash which is the results looked up via isbn
    def Apple.look_up_books(book_list)

      split_books = Apple.split_up_books_by_control_number book_list

      start_index = 0
      apple_id_lookups = Apple.get_look_up_urls_recursively split_books[:id], start_index, []
      #isbn_lookups = Apple.get_look_up_urls_recursively split_books[:isbn], start_index, [], :isbn

      #looking up the books via apple id
      #puts 'looking up by apple id...'
      Apple.look_up_apple_books_by_urls(apple_id_lookups)

      # $apple_book_hash.each do | key, book_wrapper |
      #   puts "#{key}\t#{book_wrapper[:status]}\t#{book_wrapper[:book]['title']}"
      # end

      # looking up the books without an apple id but have an isbn number.
      #puts 'looking up by epub isbn...'
      Apple.look_up_isbn_books(split_books[:isbn])

      # $isbn_book_hash.each do | key, book_wrapper |
      #   apple_id = book_wrapper[:found_apple_id].nil? ? '': book_wrapper[:found_apple_id]
      #   puts "#{key}\t#{apple_id}\t#{book_wrapper[:status]}\t#{book_wrapper[:book]["title"]}\t"
      #   #print book_wrapper[:found_apple_id] unless book_wrapper[:found_apple_id].nil?
      # end
      { apple_id: $apple_book_hash, isbn: $isbn_book_hash }
    end

    private
    # given a list of URLs built based on the ISBN
    # GET each one and mark the status to true if a result has been found
    def Apple.look_up_isbn_books(book_list)
      book_list.each do | book |
        query_url = "#{ITUNES_LOOKUP_URL}?isbn=#{book['epubIsbnItunes']}"
        response = Net::HTTP.get(URI(query_url))
        json = JSON.parse(response)

        if json['resultCount'] > 0
          book = $isbn_book_hash[book['epubIsbnItunes']]
          book[:status] = true
          book[:found_apple_id] = json['results'].first['trackId'].to_s
        end
      end
    end

    # given a list of URLs built based on the apple_id
    # GET each one and mark the status to true if
    # a result has been found.
    def Apple.look_up_apple_books_by_urls(book_urls)
      book_urls.each do | book_url |
        sleep 1.0
        response = Net::HTTP.get(URI(book_url))
        json = JSON.parse(response)

        if json['resultCount']
          results = json['results']
          #puts "found #{json['resultCount']} result(s) for #{book_url}"
          results.each do | result |
            apple_id = result["trackId"].to_s
            book = $apple_book_hash[apple_id]
            unless book.nil?
              book[:status] = true
            end
          end
        else
          #puts "nothing found for #{book_url}"
        end
      end
    end

    # There are two ways to look up books on Apple
    # 1. apple_id
    # 2. isbn
    # When looking up the book by ISBN apple does not return the ISBN they only
    # return the apple_id.
    # Apple encourages looking up by groups of 10.
    # if 6 of 10 books are on sale apple only returns 6 results. We can then
    # determine which ones didn't match by diffing what was returned, however,
    # apple doesn't return the ISBN if you look up ISBN it returns the apple_id which
    # we didn't have record of so there's no way to determine what apple_id matches
    # with what book so we have to split the two up and look up by apple_id and do
    # a one by one look up of ISBN's in order to be sure what book came back for sale
    # when we looked it up based on the ISBN.
    def Apple.split_up_books_by_control_number(book_list)
      book_hash = { id: [], isbn: [] }

      book_list.each do | book |
        if !book['appleId'].nil? && book['appleId'].strip != ''
          book_hash[:id].push book
          $apple_book_hash[book['appleId']] = { book: book, status: false }
        elsif !book["epubIsbnItunes"].nil? && book['epubIsbnItunes'].strip != ''
          book_hash[:isbn].push book
          $isbn_book_hash[book['epubIsbnItunes']] = { book: book, status: false }
        else
          #puts "skipped due to insufficient control numbers #{book['asin']}"
        end
      end
      book_hash
    end

    # this function generates the lookup urls recursively but it doesn't actually
    # request the url. See look_up_apple_books_by_urls for the code that requests the URL
    def Apple.get_look_up_urls_recursively(book_list, start_index, look_up_urls, control_number = :id)

      return look_up_urls if start_index >= book_list.count

      # get the slice of the array
      sub_group = book_list[start_index, INTERVAL]

      # we will use join on this to generate a comma delimited list of ids to lookup
      query_list = []
      control_number_field = (control_number == :id)? 'appleId' : 'epubIsbnItunes'

      # strip unnecessary whitespace from the control number otherwise it will
      # cause an error when we try to look up the url.
      sub_group.each do | book |
        query_list.push book[control_number_field].strip
      end

      query_variable = (control_number == :id)? 'id' : 'isbn'
      query_url = "#{ITUNES_LOOKUP_URL}?#{query_variable}=#{query_list.join(',')}"
      look_up_urls.push query_url

      # make sure we pass whatever was passed to us for the control_number
      # otherwise all recursive calls will default to :id
      Apple.get_look_up_urls_recursively book_list, start_index + INTERVAL, look_up_urls, control_number
      look_up_urls
    end
  end
end
