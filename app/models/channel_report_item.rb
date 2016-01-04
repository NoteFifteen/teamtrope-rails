class ChannelReportItem < ActiveRecord::Base
  belongs_to :channel_report

  def kdp_select_error?
    (kdp_select && ( !amazon || apple || nook ) )
  end

end
