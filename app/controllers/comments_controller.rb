class CommentsController < ApplicationController
	before_action :signed_in_user, only: [:show, :index, :destroy, :edit]
	before_action :load_comment, only: [:show, :index, :update, :destroy]
	
	def show
	end
	
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  def update
  	if @comment.update_attributes(comment_params)
  		flash[:success] = "Comment Edited!"
  		redirect_to @post
  	else
  		render 'edit'
  	end
  end
  
  def edit
  	@comment = Comment.find(params[:format])
  end
  
  def destroy
  	@comment.destroy
  	flash[:notice] = "Comment has been destroyed."
    
  	redirect_to @post
  end
 
  private
    def comment_params
      params.require(:comment).permit(:user_id, :content)
    end
    
    def load_comment
    	@comment = Comment.find(params[:id])
    	@post = @comment.post
    	
	  	rescue ActiveRecord::RecordNotFound
  			flash[:alert] = "The comment you were looking for could not be found."
  			redirect_to posts_path
    	
    end

end
