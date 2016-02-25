namespace :teamtrope do
  desc "Generates a list of books and the channels that they are available for sale on. \n rake teamtrope:generate_kdp_report"
  task generate_kdp_report: :environment do

    # getting the books out of parse
    book_list = Booktrope::ParseWrapper.get_books(exists: ['asin'])

    # creating and pereparing our channel report
    report = ChannelReport.create(scan_date: DateTime.now)
    report.insert_books(book_list)

    # getting the books that we expect to be in enrolled in KDP Select
    kdp_books = KdpSelectEnrollment.includes(:project).all.map(&:project)

    # marking the books that were found for sale on KDP
    report.mark_kdp_books kdp_books

    # looking up the books on amazon using the amazon/ecs api
    amazon_results = Booktrope::Amazon.look_up_books book_list

    # marking which books are on sale
    report.mark_books_for_sale_on_channel(amazon_results, :amazon)

    # looking up the books on apple
    apple_results = Booktrope::Apple.look_up_books book_list

    # reporting based on apple id
    report.mark_books_for_sale_on_channel(apple_results[:apple_id], :apple)

    # reporting based on isbn that gets mapped to apple id
    report.mark_books_for_sale_on_channel(apple_results[:isbn], :apple)

    # lookup the books on barnes and noble
    nook_results = Booktrope::Nook.look_up_books book_list
    report.mark_books_for_sale_on_channel(nook_results, :nook)
  end
end


