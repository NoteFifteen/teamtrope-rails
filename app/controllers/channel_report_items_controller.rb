class ChannelReportItemsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_channel_report_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @channel_report_items = ChannelReportItem.all
    respond_with(@channel_report_items)
  end

  def show
    respond_with(@channel_report_item)
  end

  def new
    @channel_report_item = ChannelReportItem.new
    respond_with(@channel_report_item)
  end

  def edit
  end

  def create
    @channel_report_item = ChannelReportItem.new(channel_report_item_params)
    @channel_report_item.save
    respond_with(@channel_report_item)
  end

  def update
    @channel_report_item.update(channel_report_item_params)
    respond_with(@channel_report_item)
  end

  def destroy
    @channel_report_item.destroy
    respond_with(@channel_report_item)
  end

  private
    def set_channel_report_item
      @channel_report_item = ChannelReportItem.find(params[:id])
    end

    def channel_report_item_params
      params.require(:channel_report_item).permit(:channel_report_id, :title, :kdp_select, :amazon, :apple, :nook, :amazon_link, :apple_link, :nook_link)
    end
end
