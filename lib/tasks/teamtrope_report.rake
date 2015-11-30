namespace :teamtrope do
  desc "Provided a comma delimited list of projects, enqueue all CTA signing requests. \n rake teamtrope:send_ctas PROJECT_IDS=1,2,4 ENQUEUE=1"
  task generate_kdp_report: :environment do
    book_list = Booktrope::ParseWrapper.get_books(exists: ['asin'])

    report = ChannelReport.create(scan_date: DateTime.now)
    report.insert_books(book_list)

    #report.report_hash['WEVXM5gied'].amazon = true

    #report.report_hash['i5Oini7GWm'].amazon = true

    amazon_results = Booktrope::Amazon.look_up_books book_list

    report.mark_books_for_sale_on_channel(amazon_results, :amazon)

    apple_results = Booktrope::Apple.look_up_books book_list
    report.mark_books_for_sale_on_channel(apple_results[:apple_id], :apple)
    report.mark_books_for_sale_on_channel(apple_results[:isbn], :apple)

    nook_results = Booktrope::Nook.look_up_books book_list
    report.mark_books_for_sale_on_channel(nook_results, :nook)

    #report.show_report
  end
end


