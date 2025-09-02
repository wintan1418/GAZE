class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to snippets_path
    else
      @recent_snippets = Snippet.public_snippets.includes(:user, :tags).recent.limit(6)
      @popular_tags = Tag.joins(:snippet_tags).group(:id).order('COUNT(snippet_tags.id) DESC').limit(10)
    end
  end
end
