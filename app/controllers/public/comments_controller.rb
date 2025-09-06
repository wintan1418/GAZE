class Public::CommentsController < Public::BaseController
  before_action :authenticate_user!
  before_action :set_snippet
  before_action :set_comment, only: [:destroy]
  
  def create
    @comment = @snippet.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      # Increment view count when someone interacts with the snippet
      @snippet.increment_view_count! unless @snippet.user == current_user
      
      redirect_to public_snippet_path(@snippet), notice: 'Comment posted successfully!'
    else
      Rails.logger.error "Comment save failed: #{@comment.errors.full_messages}"
      redirect_to public_snippet_path(@snippet), alert: "Failed to post comment: #{@comment.errors.full_messages.join(', ')}"
    end
  end
  
  def destroy
    if @comment.can_be_deleted_by?(current_user)
      @comment.destroy
      redirect_to public_snippet_path(@snippet), notice: 'Comment deleted.'
    else
      redirect_to public_snippet_path(@snippet), alert: 'You cannot delete this comment.'
    end
  end
  
  private
  
  def set_snippet
    @snippet = Snippet.public_snippets.friendly.find(params[:snippet_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to feed_path, alert: 'Snippet not found or is private.'
  end
  
  def set_comment
    @comment = @snippet.comments.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end