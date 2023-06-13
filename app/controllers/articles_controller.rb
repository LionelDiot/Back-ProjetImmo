class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show update destroy ]
  before_action :authenticate_user!, only: %i[edit create update destroy]
  #before_action :authenticate_user, only: %i[show index]
  # GET /articles
  def index
    @articles = Article.all
    @articles = @articles.where.not(isPrivate: true)
    
    if current_user
      private_articles = @articles.where(isPrivate: true, user_id: current_user.id)
      @articles = @articles.or(private_articles)
    end
    
    @articles = @articles.order(created_at: :desc)
  
    render json: @articles
  end
  

  
  # GET /article/1
  def show
    @article = Article.find(params[:id])
    puts(@article.id)
    if isPrivate_article? && @article.user != current_user
      render json: { error: 'You are not authorized to view this article.' }, status: :unauthorized
    else
      render json: @article
    end
  end

  # POST /articles
  def create
    
    @article = current_user.articles.build(article_params)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    unless current_user == @article.user
      render json: { error: 'You hare not authorized to update this article.' }, status: :unauthorized
      return
    end

    if @article.update(article_params)
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    unless current_user == @article.user
      render json: { error: 'You are not authorized to delete this article.' }, status: :unauthorized
      return
    end

    @article.destroy
  end

  private 
  
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :isPrivate)
    end

    def get_user_from_token
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                               Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload['sub']
      User.find(user_id.to_s)
    end

    def isPrivate_article?
      @article.isPrivate
    end
end
