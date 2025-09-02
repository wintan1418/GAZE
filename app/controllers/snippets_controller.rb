class SnippetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_snippet, only: [:show, :edit, :update, :destroy, :toggle_visibility, :raw]
  before_action :authorize_snippet!, only: [:edit, :update, :destroy, :toggle_visibility]
  
  def index
    @pagy, @snippets = pagy(current_user.snippets.includes(:tags).recent)
  end
  
  def show
    respond_to do |format|
      format.html
      format.json { render json: @snippet }
    end
  end
  
  def new
    @snippet = current_user.snippets.build
  end
  
  def create
    @snippet = current_user.snippets.build(snippet_params)
    
    if @snippet.save
      process_tags
      redirect_to @snippet, notice: 'Snippet was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @snippet.update(snippet_params)
      process_tags
      redirect_to @snippet, notice: 'Snippet was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @snippet.destroy!
    redirect_to snippets_url, notice: 'Snippet was successfully deleted.'
  end
  
  def toggle_visibility
    @snippet.toggle!(:visibility)
    redirect_back(fallback_location: @snippet, notice: "Snippet is now #{@snippet.visibility}")
  end
  
  def raw
    render plain: @snippet.code
  end
  
  def search
    query = params[:q]
    @pagy, @snippets = pagy(
      current_user.snippets
        .includes(:tags)
        .search(query)
        .recent
    )
    render :index
  end
  
  private
  
  def set_snippet
    @snippet = Snippet.find(params[:id])
  end
  
  def authorize_snippet!
    unless @snippet.user == current_user
      redirect_to snippets_path, alert: 'Not authorized to perform this action.'
    end
  end
  
  def snippet_params
    params.require(:snippet).permit(:title, :description, :code, :language, :visibility)
  end
  
  def process_tags
    return unless params[:snippet][:tag_names].present?
    
    tag_names = params[:snippet][:tag_names].split(',').map(&:strip).map(&:downcase).uniq
    
    @snippet.tags.clear
    
    tag_names.each do |tag_name|
      tag = current_user.tags.find_or_create_by(name: tag_name)
      @snippet.tags << tag unless @snippet.tags.include?(tag)
    end
  end
end