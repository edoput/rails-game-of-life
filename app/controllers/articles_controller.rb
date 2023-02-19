class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(title: "...", body: "...")
    if @article.save
      redirect to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def article_params
    params.require(:article).permt(:title, :body)
  end
end
