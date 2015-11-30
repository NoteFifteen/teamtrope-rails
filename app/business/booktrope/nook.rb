module Booktrope
  class Nook
    require 'net/http'
    $book_hash = {}
    NOOK_LOOKUP_URL = "http://www.barnesandnoble.com/s/"

    def Nook.look_up_books(book_list)
      Nook.prepare_hash book_list
      valid_list = Nook.get_valid_book_list book_list
      look_up_urls = Nook.get_look_up_urls valid_list

      Nook.look_up_books_asynchronously look_up_urls

      $book_hash.each do | key, book_wrapper |
        puts "#{key}\t#{book_wrapper[:status]}"
      end

      #File.open("/Users/Justin/Desktop/nook_results2.yaml", 'w')  { | f | f.write Marshal.dump($book_hash) }

      $book_hash
    end

    def Nook.look_up_books_asynchronously(look_up_urls)
      job_queue = JobQueue.new

      look_up_urls.each_with_index do | wrapper, index |
        job_queue.add_task( lambda { | thread_id |

            url = (wrapper[:detail_url].nil?)? wrapper[:short_url] : wrapper[:detail_url]
            puts "thread_id: #{thread_id} step #{index}/#{look_up_urls.count} #{wrapper[:bnid]} #{url}"
            uri = URI(url)

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
          }
        )
        #break if index >= 15
      end
      job_queue.perform_blocks
    end

    def Nook.look_up_books_by_urls(look_up_urls)

      i = 1
      max_tries = 3
      look_up_urls.each do | wrapper |
        #puts wrapper[:bnid]
        #puts wrapper[:short_url]
        #puts wrapper[:detail_url]

        url = (wrapper[:detail_url].nil?)? wrapper[:short_url] : wrapper[:detail_url]

        puts "step #{i}/#{look_up_urls.count} #{wrapper[:bnid]} #{url}"

        uri = URI(url)

        # move this into a function
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

    def Nook.get_valid_book_list(book_list)
      valid_list = []
      book_list.each do | book |
        unless book['bnid'].nil? || book['bnid'].strip == ''
          valid_list.push book
        end
      end
      valid_list
    end

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
