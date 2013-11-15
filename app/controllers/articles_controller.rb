class ArticlesController < ApplicationController
  include ArticlesHelper

  before_filter :require_login, except: [:index, :show]
  before_filter :require_author, only: [:destroy, :edit]

  def index
    if params.has_key?(:month)
      @articles = Article.find_by_month(params[:month])
    else
      @articles = Article.all
    end
    @pages = Page.all
  end

  def show
    @article = Article.find(params[:id])
    @article.viewed!
    @comment = Comment.new
    @comment.article_id = @article.id
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.author = current_user
    @article.save
    flash.notice = "Article '#{@article.title}' created!"

    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash.notice = "Article '#{@article.title}' deleted!"

    redirect_to articles_path
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)

    flash.notice = "Article '#{@article.title}' updated!"

    redirect_to article_path(@article)
  end

  def archive
    @months = Article.months_range
  end

  def top
    @articles = Article.all.order('view_count DESC')[0, 3]
    render 'articles/index'
  end

  private

    def require_author
      @article = Article.find(params[:id])
      unless @article.author == current_user
        redirect_to article_path(@article), notice: 'Author required!'
      end
    end
end
