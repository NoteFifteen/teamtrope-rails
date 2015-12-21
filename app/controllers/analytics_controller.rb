class AnalyticsController < ApplicationController
require 'pp'
  def show
    @project = Project.friendly.find(params[:project_id])

    response = { no_data: true }

    case params[:channel]
    when "amazon"

      # Test with ASIN B00GJ1XZSS
      if @project.control_number.try(:asin)
        sales_result = Parse::Cloud::Function.new('getSalesDataForAsin').call('asin'=> @project.control_number.asin)
        rank_result = Parse::Cloud::Function.new('getCrawlDataForAsin').call('asin'=> @project.control_number.asin)

        #puts sales_result['crawl'].map{ |crawl_data| [Time.parse(crawl_data['crawlDate']['iso']).utc.to_i * 1000, crawl_data['dailySales']] }.reject!{ |crawl_data| crawl_data[1].nil? }.inspect

        sales_data_tmp = sales_result['crawl'].map{ |crawl_data| [Time.parse(crawl_data['crawlDate']['iso']).utc.to_i * 1000, crawl_data['dailySales']] }
        sales_data = []
        sales_data_tmp.each do | item |
          sales_data.push item if item[1] != nil
        end

        response = {
          sales: {
            title: sales_result['title'],
            data:           sales_data.inspect,
            kdp_unlimited:  sales_result['crawl'].map{ |crawl_data| [Time.parse(crawl_data['crawlDate']['iso']).utc.to_i * 1000, crawl_data['dailyKdpUnlimited'  ]] }.reject{ | crawl_data | crawl_data[1] == nil }.inspect,
            kpd_free_promo: sales_result['crawl'].map{ |crawl_data| [Time.parse(crawl_data['crawlDate']['iso']).utc.to_i * 1000, crawl_data['dailyFreeUnitsPromo']] }.reject{ | crawl_data | crawl_data[1] == nil }.inspect
          },
          rank: {
            title: rank_result['title'],
            price_data: rank_result['crawl'].reject{|crawl_data| !crawl_data['got_price'] }.map{ |crawl_data|  [Time.parse(crawl_data['crawl_date']['iso']).utc.to_i*1000, crawl_data['kindle_price']] }.inspect,
            rank_data: rank_result['crawl'].map{|crawl_data| [Time.parse(crawl_data['crawl_date']['iso']).utc.to_i*1000, crawl_data['sales_rank']]}.inspect,
          },
          no_data: false
        }
        pp response

      end
    when "nook"
      if @project.control_number.try(:parse_id)
        sales_result = Parse::Cloud::Function.new('getSalesDataForNook').call('book' => @project.control_number.parse_id)
        response = {
          sales: {
            title: sales_result['title'].nil?? @project.book_title : sales_result['title'],
            data: sales_result['crawl'].map{ |crawl_data| [Time.parse(crawl_data['crawlDate']['iso']).utc.to_i * 1000, crawl_data['nookSales']]}.inspect
          },
          no_data: false
        }
      end
    when "apple"
      if @project.control_number.try(:parse_id)
        sales_result = Parse::Cloud::Function.new('getSalesDataForApple').call('book' => @project.control_number.parse_id)
        puts sales_result['title']
        response = {
          sales: {
            title: sales_result['title'].nil?? @project.book_title : sales_result['title'],
            data: sales_result['crawl'].map{ |crawl_data| [Time.parse(crawl_data['crawlDate']['iso']).utc.to_i * 1000, crawl_data['appleSales']]}.inspect
          },
          no_data: false
        }
      end
    else
      response[:error] = { messages: ["channel #{params[:channel]} is not supported"] }
    end

    # respond_to do |format|
    #   format.json { render json: response }
    # end
    render json: response

  end
end
