class BookbubSubmissionsController < ApplicationController
  before_action :set_bookbub_submission, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @bookbub_submissions = BookbubSubmission.all
    respond_with(@bookbub_submissions)
  end

  def show
    respond_with(@bookbub_submission)
  end

  def new
    @bookbub_submission = BookbubSubmission.new
    respond_with(@bookbub_submission)
  end

  def edit
  end

  def create
    @bookbub_submission = BookbubSubmission.new(bookbub_submission_params)
    @bookbub_submission.save
    respond_with(@bookbub_submission)
  end

  def update
    @bookbub_submission.update(bookbub_submission_params)
    respond_with(@bookbub_submission)
  end

  def destroy
    @bookbub_submission.destroy
    respond_with(@bookbub_submission)
  end

  private
    def set_bookbub_submission
      @bookbub_submission = BookbubSubmission.find(params[:id])
    end

    def bookbub_submission_params
      params.require(:bookbub_submission).permit(:project_id, :submitted_by_id, :author, :title, :asin, :asin_linked_url, :current_price, :num_stars, :num_reviews, :avg_rating, :num_pages)
    end
end
