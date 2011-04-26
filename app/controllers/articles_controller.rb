class ArticlesController < ApplicationController
  before_filter :load_article, :except => [:index, :create, :search, :new]

  def search
    if params[:use_highlights]
      @articles = Article.highlight_tsearch(params[:search])
    else
      @articles = Article.plain_tsearch(params[:search])
    end

    respond_to do |format|
      format.html { render :index }
      format.js { @articles }
    end
  end

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])

    if @article.save
      redirect_to(@article, :notice => 'Article was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @article.update_attributes(params[:article])
      redirect_to(@article, :notice => 'Article was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @article.destroy
    redirect_to(articles_url)
  end

  private

  def load_article
    @article = Article.find(params[:id])
  end
end
