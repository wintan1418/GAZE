class Public::StacksController < Public::BaseController
  def index
    @pagy, @stacks = pagy(
      Stack.public_stacks
        .includes(:user, :snippets)
        .recent
    )
  end

  def show
    @stack = Stack.public_stacks.find(params[:id])
    @pagy, @snippets = pagy(
      @stack.snippets
        .public_snippets
        .includes(:user, :tags)
        .recent
    )
  rescue ActiveRecord::RecordNotFound
    redirect_to public_stacks_path, alert: 'Stack not found or is private.'
  end
end