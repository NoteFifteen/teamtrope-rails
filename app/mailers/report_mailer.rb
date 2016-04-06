class ReportMailer < ActionMailer::Base

  def amazon_publication_date_sync(csv_text)
    @report_date = Time.now.strftime("%Y-%d-%m-%H:%M:%S")
    attachment_name = "amazon_publication_date_sync_#{@report_date}.csv"
    attachments[attachment_name] = {
      mime_type: "text/csv",
      content: csv_text
    }
    subject = "Amazon Publication Date Sync #{@report_date}"
    send_email_message('amazon_publication_date_sync', {}, amazon_publication_date_sync_recipients, subject)
  end

  def send_dashbook_email(csv_text, report_date)
    attachment_name = "dashbook_#{report_date}.csv"
    attachments[attachment_name] = {
      mime_type: "text/csv",
      content: csv_text,
      encoding: 'quoted-printable'
    }

    @report_date = report_date
    send_email_message('dashbook', {}, dashbook_recipients, "Dashbook #{Date.today.strftime("%m/%d/%Y")}")
  end

  def master_spread_sheet(csv_text, report_date)
    attachment_name = "master_metadata_spreadsheet_#{report_date}.csv"
    attachments[attachment_name] = {  mime_type: "text/csv",
                                      content: csv_text,
                                      encoding: 'quoted-printable'}

    @report_date = report_date

    send_email_message('master_spread_sheet', {}, master_spreadsheet_recipients, "Master Meta Spreadsheet #{Date.today.strftime('%m/%d/%Y')}")

  end

  def prefunk_scribd_email_report(csv_text, current_user)
    @report_date = Time.now.strftime("%Y-%d-%m-%H:%M:%S")
    attachment_name = "prefunk_enrollment_scribd_export_#{@report_date}.csv"
    attachments[attachment_name] = {
      mime_type: 'text/csv',
      content: csv_text,
      encoding: 'quoted-printable'
    }
    @report_date = Time.now.strftime('%m/%d/%Y %H:%M:%S')
    subject = "Prefunk Enrollment Scribd Export for #{@report_date}"
    send_email_message('prefunk_scribd_email_report', {}, [current_user.email], subject)
  end

  def send_monthly_published_boooks_report(csv_text, current_user)
    @report_date = Time.now.strftime("%Y-%B")
    attachment_name = "monlthly_published_books_report_#{@report_date}.csv"
    attachments[attachment_name] = {
      mime_type: 'text/csv',
      content: csv_text,
      encoding: 'quoted-printable'
    }

    subject = "Monthly Published Books Report for #{@report_date}"
    send_email_message('monthly_published_books', {}, [current_user.email], subject)
  end

  def print_price_update(updated_report, needs_updating_report)

    @report_date = Time.now.strftime('%m/%d/%Y %H:%M:%S')
    updated_attachment_name = "updated_print_price_report_#{@report_date}.csv"
    needs_updating_attachment_name = "needs_updating_report_#{@report_date}.csv"

    attachments[updated_attachment_name] = {
      mime_type: 'text/csv',
      content: updated_report,
      encoding: 'quoted-printable'
    }

    attachments[needs_updating_attachment_name] = {
      mime_type: 'text/csv',
      content: needs_updating_report,
      encoding: 'quoted-printable'
    }

    subject = "Print Price Update Report"
    send_email_message('print_price_update_report', {}, print_price_update_report_recipients, subject)

  end

  def scribd_email_report(csv_text, current_user)
    attachment_name = "scribd_metadata_export.csv"
    attachments[attachment_name] = {
      mime_type: "text/csv",
      content: csv_text,
      encoding: 'quoted-printable'
    }
    @report_date = Time.now.strftime('%m/%d/%Y %H:%M:%S')

    send_email_message('scribd_metadata_export', {}, [current_user.email], "Scribd Metada Spreadsheet #{@report_date}")
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

  def dashbook_recipients
    %w( tt_dashbook@booktrope.com )
  end

  def amazon_publication_date_sync_recipients
    %w( tt_amazon_publication_date_sync@booktrope.com )
  end

  def master_spreadsheet_recipients
    %w( tt_metadata_export_list@booktrope.com )
  end

  def print_price_update_report_recipients
      %w( tt_print_price_update_list@booktrope.com )
  end

end
