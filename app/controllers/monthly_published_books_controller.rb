class MonthlyPublishedBooksController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_monthly_published_book, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @monthly_published_books = MonthlyPublishedBook.all.order(report_date: :desc)
    respond_with(@monthly_published_books)
  end

  def show
    respond_with(@monthly_published_book)
  end

  def new
    @monthly_published_book = MonthlyPublishedBook.new
    respond_with(@monthly_published_book)
  end

  def edit
  end

  def create
    @monthly_published_book = MonthlyPublishedBook.new(monthly_published_book_params)
    @monthly_published_book.save
    respond_with(@monthly_published_book)
  end

  def update
    @monthly_published_book.update(monthly_published_book_params)
    respond_with(@monthly_published_book)
  end

  def destroy
    @monthly_published_book.destroy
    respond_with(@monthly_published_book)
  end

  def email_report
    csv_text = MonthlyPublishedBook.csv_export
    ReportMailer.send_monthly_published_boooks_report(csv_text, current_user)
  end

  private
    def set_monthly_published_book
      @monthly_published_book = MonthlyPublishedBook.find(params[:id])
    end

    def monthly_published_book_params
      params.require(:monthly_published_book).permit(:report_date, :published_monthly, :published_total, :published_books)
    end
end
