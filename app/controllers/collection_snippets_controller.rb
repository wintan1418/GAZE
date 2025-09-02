class CollectionSnippetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection
  before_action :authorize_collection!
  
  def index
    @pagy, @snippets = pagy(@collection.snippets.includes(:tags).recent)
  end
  
  def create
    @snippet = current_user.snippets.find(params[:snippet_id])
    
    unless @collection.snippets.include?(@snippet)
      @collection.snippets << @snippet
      flash[:notice] = 'Snippet added to collection.'
    else
      flash[:alert] = 'Snippet is already in this collection.'
    end
    
    redirect_back(fallback_location: @collection)
  end
  
  def destroy
    @snippet = @collection.snippets.find(params[:id])
    @collection.snippets.delete(@snippet)
    
    redirect_back(fallback_location: @collection, notice: 'Snippet removed from collection.')
  end
  
  private
  
  def set_collection
    @collection = current_user.collections.find(params[:collection_id])
  end
  
  def authorize_collection!
    unless @collection.user == current_user
      redirect_to collections_path, alert: 'Not authorized to perform this action.'
    end
  end
end