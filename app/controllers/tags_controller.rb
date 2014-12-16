class TagsController < ApplicationController

	before_action :set_tag, only: [:show, :update, :edit, :destroy]

	#Create a tag cloud or use the taggable gem to do it.
  #def index
  #	@tags = Tag.all
  #end

  def show
  end

  def new
  	@tag = Tag.new
  end

  def create
  	@tag = Tag.new(tag_params)
  	if @tag.save
  		flash[:success] = "New Tag created."
  		redirect_to @tag
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
  	if @tag.update(tag_params)
  		flash[:notice] = "Tag updated."
  		redirect_to @tag
  	else
  		render 'edit'
  	end
  end

  def destroy
  	@tag.destroy
  	flash[:notice] = "Tag has been destroyed."
    redirect_to tags_path
  end
  
  private
  	def set_tag
  		@tag = Tag.find(params[:id])
  		rescue ActiveRecord::RecordNotFound
  			flash[:alert] = "The Tag you were looking for could not be loaded."
  			redirect_to tags_path
  	end
  	
  	def tag_params
  		params.require(:tag).permit(:name)
  	end
end
