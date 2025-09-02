class Public::SnippetsController < Public::BaseController
  def index
    @pagy, @snippets = pagy(
      Snippet.public_snippets
        .includes(:user, :tags)
        .recent
    )
  end
  
  def show
    @snippet = Snippet.public_snippets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to public_snippets_path, alert: 'Snippet not found or is private.'
  end
  
  def search
    query = params[:q]
    @pagy, @snippets = pagy(
      Snippet.public_snippets
        .includes(:user, :tags)
        .search(query)
        .recent
    )
    render :index
  end
end