class EbookOnlyIncentivesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :show
  before_action :set_ebook_only_incentive, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ebook_only_incentives = EbookOnlyIncentive.all
    respond_with(@ebook_only_incentives)
  end

  def show
    respond_with(@ebook_only_incentive)
  end

  def new
    @ebook_only_incentive = EbookOnlyIncentive.new
    respond_with(@ebook_only_incentive)
  end

  def edit
  end

  def create
    @ebook_only_incentive = EbookOnlyIncentive.new(ebook_only_incentive_params)
    @ebook_only_incentive.save
    respond_with(@ebook_only_incentive)
  end

  def update
    if @ebook_only_incentive.update(ebook_only_incentive_params)

      @project.create_activity :edited_ebook_only_incentive, owner: current_user,
                               parameters: {
                                    text: "Edited eBook Only Incentive",
                                    object_id: @ebook_only_incentive.id,
                                    form_data: params[:ebook_only_incentive].to_s
                              }

      ProjectMailer.ebook_only_incentive(@project, current_user)
      flash[:success] = 'Updated eBook Only Incentive'
    else
      flash[:danger] = 'There was problem updating the eBook Only Incentive'
    end


    respond_with(@ebook_only_incentive)
  end

  def destroy
    @ebook_only_incentive.destroy
    respond_with(@ebook_only_incentive)
  end

  private
    def set_ebook_only_incentive
      @ebook_only_incentive = EbookOnlyIncentive.find(params[:id])
    end

    def set_project
      @project = @ebook_only_incentive.project
    end

    def ebook_only_incentive_params
      params.require(:ebook_only_incentive).permit(:project_id, :title, :author_name, :publication_date, :retail_price, :blurb, :website_one, :website_two, :website_three, :category_one, :category_two, :praise, :isbn)
    end
end
