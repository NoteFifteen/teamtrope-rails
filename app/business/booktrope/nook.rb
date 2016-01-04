module Booktrope
  class Nook
    require 'net/http'
    $book_hash = {}
    NOOK_LOOKUP_URL = "http://www.barnesandnoble.com/s/"

    # main driver function for looking up books on nook
    def Nook.look_up_books(book_list)
      Nook.prepare_hash book_list
      valid_list = Nook.get_valid_book_list book_list
      look_up_urls = Nook.get_look_up_urls valid_list

      # look up the books on barnes and noble using a multithreaded queue.
      Nook.look_up_books_asynchronously look_up_urls

      # $book_hash.each do | key, book_wrapper |
      #   puts "#{key}\t#{book_wrapper[:status]}"
      # end

      #File.open("/Users/Justin/Desktop/nook_results2.yaml", 'w')  { | f | f.write Marshal.dump($book_hash) }

      $book_hash
    end

    # look up the books asynchronously using a job que
    def Nook.look_up_books_asynchronously(look_up_urls)
      #create the job queue
      job_queue = JobQueue.new

      look_up_urls.each_with_index do | wrapper, index |
        # queuing up tasks via a block/lambda
        job_queue.add_task( lambda { | thread_id |

            url = (wrapper[:detail_url].nil?)? wrapper[:short_url] : wrapper[:detail_url]
            puts "thread_id: #{thread_id} step #{index}/#{look_up_urls.count} #{wrapper[:bnid]} #{url}"
            uri = URI(url)

            # retry 3 times if there is a failure
            max_tries = 3
            done = false
            j = 0
            while !done
              puts 'retrying' if j > 0
              begin
                response = Net::HTTP.get_response(uri)
                done = true
              rescue Exception => e
                pp e
                j = j + 1
                if j >= max_tries
                  done = true
                end
                sleep 3.0
              end
            end

            case response
            #found for sale
            # HTTPMovedPermanently -> found via /s/<bnid> link
            # HTTPOK -> found via :detail_url
            when Net::HTTPMovedPermanently, Net::HTTPOK
              book_wrapper = $book_hash[wrapper[:bnid].strip]
              book_wrapper[:status] = true
              book_wrapper[:location] = "http://barnesandnoble.com/s/#{wrapper[:bnid].strip}"
              #puts "On Sale"
            #not on sale
            when Net::HTTPFound
            #puts "Not on Sale"
            #puts response['location']
            end
            sleep 3.0
          }
        )
        #break if index >= 15
      end
      job_queue.perform_blocks
    end

    # this function is no longer being used.
    # given a list of URLS it looks up the book on barnes and noble.
    # will retry 3 times upon an error.
    def Nook.look_up_books_by_urls(look_up_urls)

      i = 1
      max_tries = 3
      look_up_urls.each do | wrapper |
        #puts wrapper[:bnid]
        #puts wrapper[:short_url]
        #puts wrapper[:detail_url]

        url = (wrapper[:detail_url].nil?)? wrapper[:short_url] : wrapper[:detail_url]

        #puts "step #{i}/#{look_up_urls.count} #{wrapper[:bnid]} #{url}"

        uri = URI(url)

        # move this into a function
        done = false
        j = 0
        while !done
          #puts 'retrying' if j > 0
          begin
            response = Net::HTTP.get_response(uri)
            done = true
          rescue Exception => e
            pp e
            j = j + 1
            if j >= max_tries
              done = true
            end
            sleep 3.0
          end
        end

        case response
        #found for sale
        # HTTPMovedPermanently -> found using /s/<bnid> link
        # HTTPOK -> found using the :detail_url
        when Net::HTTPMovedPermanently, Net::HTTPOK
          book_wrapper = $book_hash[wrapper[:bnid].strip]
          book_wrapper[:status] = true
          #puts "On Sale"
        #not on sale
        when Net::HTTPFound
        #puts "Not on Sale"
        #puts response['location']
        end

        sleep 3.0
        #break if i > 15

        i = i + 1
      end
    end

    # filters out bad data from the book list which is what we use to look up
    def Nook.get_valid_book_list(book_list)
      valid_list = []
      book_list.each do | book |
        unless book['bnid'].nil? || book['bnid'].strip == ''
          valid_list.push book
        end
      end
      valid_list
    end

    # get the look up urls for each book in the book list
    def Nook.get_look_up_urls(book_list)
      look_up_urls = []
      book_list.each do | book |
        look_up_urls.push(
          {
            short_url: "#{NOOK_LOOKUP_URL}#{book['bnid'].strip}",
            detail_url: book['detailPageUrlNook'],
            bnid: book['bnid']
          }
        )
      end
      look_up_urls
    end

    # prepares the $book_hash which is the results that gets returned for the report.
    # the hash maps the bnid to the parse book and a status flag. True indicates
    # that the book is for sale on the store.
    def Nook.prepare_hash(book_list)
      book_list.each do | book |
        unless book['bnid'].nil? || book['bnid'].strip == ''
          $book_hash[book['bnid'].strip] = { book: book, status: false }
        else
          puts "Skipped no BNID for #{book['asin']}"
        end
      end
    end
  end
end
