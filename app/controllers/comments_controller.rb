class CommentsController < ApplicationController
	before_action :signed_in_user, only: [:show, :index, :destroy, :edit]
	
	def show
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
	end
	
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  def update
	  @post = Post.find(params[:post_id])
  	@comment = @post.comments.find(params[:id])
  	if @comment.update_attributes(comment_params)
  		flash[:success] = "Comment Edited!"
  		redirect_to @post
  	else
  		render 'edit'
  	end
  end
  
  def edit
	  @post = Post.find(params[:post_id])
	  @comment = @post.comments.find(params[:id])
  end
  
  def destroy
  	@post = Post.find(params[:post_id])
  	@comment = @post.comments.find(params[:id])
  	@comment.destroy
  	flash[:notice] = "Comment has been destroyed."
    
  	redirect_to @post
  end
 
  private
    def comment_params
      params.require(:comment).permit(:user_id, :content)
    end
    

end
