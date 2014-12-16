class PostsController < ApplicationController

	before_action :signed_in_user, only: [:show, :index, :destroy, :edit]
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	
  def new
  	@post = Post.new
  	@post.post_tags.build
  end

  def create
  	@post = Post.new(post_params)
  	if @post.save
  		flash[:success] = "New Post Created!"
  		redirect_to @post
  	else
  		render 'new'
  	end
  end

	def edit
	end

  def update
		if @post.update_attributes(post_params)
			flash[:success] = "Post Updated!"
			redirect_to @post
		else
			render 'edit'
		end  
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post has been destroyed."
    redirect_to posts_path
  end

  def show
  end

  def index
  	@posts = Post.all
  end
  
  private
  	def post_params
  		params.require(:post).permit(:title, :post_date, :author_id, :content, :poster_image, :tag_ids => [])
  	end
  	
  	def set_post
  		@post = Post.find(params[:id])
	  	rescue ActiveRecord::RecordNotFound
  			flash[:alert] = "The post you were looking for could not be found."
  			redirect_to posts_path
	  end
  	
end
