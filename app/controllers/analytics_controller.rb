class AnalyticsController < ApplicationController

  def show
    @project = Project.friendly.find(params[:project_id])

    # Test with ASIN B00GJ1XZSS
    if @project.control_number.try(:asin)
      sales_result = Parse::Cloud::Function.new('getSalesDataForAsin').call('asin'=> @project.control_number.asin)
      rank_result = Parse::Cloud::Function.new('getCrawlDataForAsin').call('asin'=> @project.control_number.asin)

      response = {
          sales: {
              title: sales_result['title'],
              data: sales_result['crawl'].map{ |crawl_data| [Time.parse(crawl_data['crawlDate']['iso']).utc.to_i * 1000, crawl_data['dailySales']] }.inspect
          },
          rank: {
              title: rank_result['title'],
              price_data: rank_result['crawl'].reject{|crawl_data| !crawl_data['got_price'] }.map{ |crawl_data|  [Time.parse(crawl_data['crawl_date']['iso']).utc.to_i*1000, crawl_data['kindle_price']] }.inspect,
              rank_data: rank_result['crawl'].map{|crawl_data| [Time.parse(crawl_data['crawl_date']['iso']).utc.to_i*1000, crawl_data['sales_rank']]}.inspect
          }
      }
    else
      response = {
          no_data: true
      }
    end

    # respond_to do |format|
    #   format.json { render json: response }
    # end

    render json: response

  end
end
