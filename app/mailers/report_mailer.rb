class ReportMailer < ActionMailer::Base

  def master_spread_sheet(csv_text, report_date)
    attachment_name = "master_metadata_spreadsheet_#{report_date}.csv"
    attachments[attachment_name] = {  mime_type: "text/csv",
                                      content: csv_text,
                                      encoding: 'quoted-printable'}

    @report_date = report_date

    send_email_message('master_spread_sheet', {}, master_spreadsheet_recipients, "Master Meta Spreadsheet #{Date.today.strftime('%m/%d/%Y')}")

  end

  # Generic email send pattern that just passes a simple hash table
  def send_email_message (template_name, message_tokens, recipient_list, subject)
    recipient_list = Array(recipient_list) unless recipient_list.is_a?(Array)

    # TODO: determine if message_tokens are necessary
    # hold over from ProjectMailer
    @message_tokens = message_tokens

    recipient_list.each do |recipient|
      mail( to: recipient,
            subject: subject,
            template_name: template_name
      ).deliver
    end
  end

  def master_spreadsheet_recipients
    %w( tt_metadata_export_list@booktrope.com )
  end

end
