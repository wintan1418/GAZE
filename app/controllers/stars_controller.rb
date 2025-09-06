class StarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_snippet
  
  def create
    @star = current_user.stars.build(snippet: @snippet)
    
    if @star.save
      redirect_to @snippet, notice: 'Snippet starred!'
    else
      redirect_to @snippet, alert: 'Failed to star snippet.'
    end
  end
  
  def destroy
    @star = current_user.stars.find_by(snippet: @snippet)
    
    if @star&.destroy
      redirect_to @snippet, notice: 'Star removed.'
    else
      redirect_to @snippet, alert: 'Failed to remove star.'
    end
  end
  
  private
  
  def set_snippet
    @snippet = Snippet.friendly.find(params[:snippet_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to snippets_path, alert: 'Snippet not found.'
  end
end