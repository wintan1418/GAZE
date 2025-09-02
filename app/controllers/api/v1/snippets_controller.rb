class Api::V1::SnippetsController < Api::BaseController
  def index
    @pagy, @snippets = pagy(Snippet.public_snippets.includes(:user, :tags).recent)
    
    render json: {
      data: @snippets.as_json(include: [:user, :tags]),
      meta: pagy_metadata(@pagy)
    }
  end
  
  def show
    @snippet = Snippet.public_snippets.find(params[:id])
    
    render json: @snippet.as_json(include: [:user, :tags])
  end
end