class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_snippet
  before_action :set_comment, only: [:destroy]
  
  def create
    @comment = @snippet.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to @snippet, notice: 'Comment posted successfully!'
    else
      redirect_to @snippet, alert: 'Failed to post comment. Please try again.'
    end
  end
  
  def destroy
    if @comment.can_be_deleted_by?(current_user)
      @comment.destroy
      redirect_to @snippet, notice: 'Comment deleted.'
    else
      redirect_to @snippet, alert: 'You cannot delete this comment.'
    end
  end
  
  private
  
  def set_snippet
    @snippet = current_user.snippets.find(params[:snippet_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to snippets_path, alert: 'Snippet not found.'
  end
  
  def set_comment
    @comment = @snippet.comments.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end