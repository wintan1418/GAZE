class StacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stack, only: [:show, :edit, :update, :destroy, :add_snippet, :remove_snippet]

  def index
    @pagy, @stacks = pagy(current_user.stacks.includes(:snippets).recent)
  end

  def show
    @pagy, @snippets = pagy(@stack.snippets.includes(:user, :tags).recent)
  end

  def new
    @stack = current_user.stacks.build
  end

  def create
    @stack = current_user.stacks.build(stack_params)
    
    if @stack.save
      redirect_to @stack, notice: 'Stack created successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stack.update(stack_params)
      redirect_to @stack, notice: 'Stack updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stack.destroy
    redirect_to stacks_path, notice: 'Stack deleted successfully!'
  end

  def add_snippet
    snippet = current_user.snippets.find(params[:snippet_id])
    
    if @stack.snippets.exists?(snippet.id)
      redirect_back(fallback_location: @stack, alert: 'Snippet already in this stack.')
    else
      @stack.snippets << snippet
      redirect_back(fallback_location: @stack, notice: 'Snippet added to stack!')
    end
  end

  def remove_snippet
    snippet = @stack.snippets.find(params[:snippet_id])
    @stack.snippets.delete(snippet)
    redirect_back(fallback_location: @stack, notice: 'Snippet removed from stack.')
  end

  private

  def set_stack
    @stack = current_user.stacks.find(params[:id])
  end

  def stack_params
    params.require(:stack).permit(:name, :description, :color, :visibility)
  end
end