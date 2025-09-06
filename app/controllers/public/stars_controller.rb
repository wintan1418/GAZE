class Public::StarsController < Public::BaseController
  before_action :authenticate_user!
  before_action :set_snippet
  
  def create
    @star = current_user.stars.build(snippet: @snippet)
    
    if @star.save
      redirect_to public_snippet_path(@snippet), notice: 'Snippet starred!'
    else
      redirect_to public_snippet_path(@snippet), alert: 'Failed to star snippet.'
    end
  end
  
  def destroy
    @star = current_user.stars.find_by(snippet: @snippet)
    
    if @star&.destroy
      redirect_to public_snippet_path(@snippet), notice: 'Star removed.'
    else
      redirect_to public_snippet_path(@snippet), alert: 'Failed to remove star.'
    end
  end
  
  private
  
  def set_snippet
    @snippet = Snippet.public_snippets.friendly.find(params[:snippet_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to feed_path, alert: 'Snippet not found or is private.'
  end
end