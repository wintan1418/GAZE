class Public::SnippetsController < Public::BaseController
  def index
    @pagy, @snippets = pagy(
      Snippet.public_snippets
        .includes(:user, :tags)
        .recent
    )
  end

  def feed
    @sort_by = params[:sort_by] || 'recent'
    
    base_query = Snippet.public_snippets.includes(:user, :tags)
    
    @snippets_query = case @sort_by
    when 'most_viewed'
      base_query.most_viewed
    when 'most_copied'  
      base_query.most_copied
    when 'most_starred'
      base_query.most_starred
    when 'trending'
      base_query.trending
    else
      base_query.recent
    end
    
    @pagy, @snippets = pagy(@snippets_query)
    
    # Get popular tags for sidebar
    @popular_tags = Tag.joins(:snippets)
                       .where(snippets: { visibility: :public_snippet })
                       .group('tags.id')
                       .order('COUNT(snippets.id) DESC')
                       .limit(10)
  end
  
  def show
    @snippet = Snippet.public_snippets.find(params[:id])
    
    # Increment view count unless it's the owner viewing their own snippet
    unless user_signed_in? && @snippet.user == current_user
      @snippet.increment_view_count!
    end
    
  rescue ActiveRecord::RecordNotFound
    redirect_to public_snippets_path, alert: 'Snippet not found or is private.'
  end
  
  def search
    query = params[:q]
    @sort_by = params[:sort_by] || 'recent'
    
    Rails.logger.info "Search params: #{params.inspect}"
    Rails.logger.info "Query: #{query}, Sort: #{@sort_by}"
    
    if query.blank?
      redirect_to feed_path and return
    end
    
    begin
      base_query = Snippet.public_snippets
                          .includes(:user, :tags, :comments, :stars)
                          .search(query)
      
      Rails.logger.info "Base query count: #{base_query.count}"
      
      @snippets_query = case @sort_by
      when 'most_viewed'
        base_query.most_viewed
      when 'most_copied'  
        base_query.most_copied
      when 'most_starred'
        base_query.most_starred
      when 'trending'
        base_query.trending
      else
        base_query.recent
      end
      
      @pagy, @snippets = pagy(@snippets_query, items: 20)
      
      Rails.logger.info "Final snippets count: #{@snippets.count}"
      
      respond_to do |format|
        format.html do
          # Get popular tags for sidebar
          @popular_tags = Tag.joins(:snippets)
                             .where(snippets: { visibility: :public_snippet })
                             .group('tags.id')
                             .order('COUNT(snippets.id) DESC')
                             .limit(10)
          
          render :feed
        end
        
        format.json do
          render json: {
            snippets: @snippets.limit(10).map do |snippet|
              {
                id: snippet.id,
                slug: snippet.slug,
                title: snippet.title,
                language: snippet.language,
                user_name: snippet.user.username,
                view_count: snippet.view_count,
                stars_count: snippet.stars.count,
                comments_count: snippet.comments.count,
                created_at: snippet.created_at.strftime('%B %d, %Y')
              }
            end,
            total: @pagy.count,
            query: query
          }
        end
      end
      
    rescue => e
      Rails.logger.error "Search error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      redirect_to feed_path, alert: "Search failed. Please try again."
    end
  end
end