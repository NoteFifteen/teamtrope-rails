class ChannelReportsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_channel_report, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @channel_reports = ChannelReport.all
    respond_with(@channel_reports)
  end

  def show
    respond_with(@channel_report)
  end

  def new
    @channel_report = ChannelReport.new
    respond_with(@channel_report)
  end

  def edit
  end

  def create
    @channel_report = ChannelReport.new(channel_report_params)
    @channel_report.save
    respond_with(@channel_report)
  end

  def update
    @channel_report.update(channel_report_params)
    respond_with(@channel_report)
  end

  def destroy
    @channel_report.destroy
    respond_with(@channel_report)
  end

  private
    def set_channel_report
      @channel_report = ChannelReport.find(params[:id])
    end

    def channel_report_params
      params.require(:channel_report).permit(:scan_date)
    end
end
