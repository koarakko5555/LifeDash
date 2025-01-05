class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index] # ログイン必須のアクションを設定
  before_action :set_post, only: %i[show edit update destroy] # 必要なアクションのみに限定

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = '投稿しました'
      redirect_to posts_path
    else
      flash[:alert] = '投稿に失敗しました'
      render :new
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: '投稿を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.limit(10).order(created_at: :desc)
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.user == current_user
      @post.destroy
      flash[:notice] = '投稿が削除されました'
    end
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id]) # 正しい投稿を取得
    redirect_to posts_path, alert: '投稿が見つかりません。' unless @post
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
