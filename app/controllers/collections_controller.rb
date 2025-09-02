class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :authorize_collection!, only: [:edit, :update, :destroy]
  
  def index
    @pagy, @collections = pagy(current_user.collections.includes(:snippets).recent)
  end
  
  def show
    @pagy, @snippets = pagy(@collection.snippets.includes(:tags).recent)
  end
  
  def new
    @collection = current_user.collections.build
  end
  
  def create
    @collection = current_user.collections.build(collection_params)
    
    if @collection.save
      redirect_to @collection, notice: 'Collection was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @collection.update(collection_params)
      redirect_to @collection, notice: 'Collection was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @collection.destroy!
    redirect_to collections_url, notice: 'Collection was successfully deleted.'
  end
  
  private
  
  def set_collection
    @collection = Collection.find(params[:id])
  end
  
  def authorize_collection!
    unless @collection.user == current_user
      redirect_to collections_path, alert: 'Not authorized to perform this action.'
    end
  end
  
  def collection_params
    params.require(:collection).permit(:name, :description, :visibility)
  end
end