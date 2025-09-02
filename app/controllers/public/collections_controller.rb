class Public::CollectionsController < Public::BaseController
  def index
    @pagy, @collections = pagy(
      Collection.public_collections
        .includes(:user, :snippets)
        .recent
    )
  end
  
  def show
    @collection = Collection.public_collections.find(params[:id])
    @pagy, @snippets = pagy(@collection.snippets.public_snippets.includes(:tags).recent)
  rescue ActiveRecord::RecordNotFound
    redirect_to public_collections_path, alert: 'Collection not found or is private.'
  end
end