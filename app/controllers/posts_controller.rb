class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index] # ログイン必須のアクションを設定
  before_action :set_post, only: %i[show edit update destroy generate_comment] # 必要なアクションのみに限定

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

  # 新規追加: generate_comment アクション
  def generate_comment
    require 'net/http'

    # OpenAI APIキーを設定
    api_key = "your_openai_api_key"
    uri = URI("https://api.openai.com/v1/chat/completions")

    # ChatGPTへのリクエストデータ
    body = {
      model: "gpt-3.5-turbo",
      messages: [
        { role: "system", content: "You are a helpful assistant who gives constructive comments about diary entries." },
        { role: "user", content: "日記の内容: #{@post.content}" }
      ],
      temperature: 0.7
    }

    # HTTPリクエストを送信
    response = Net::HTTP.post(
      uri,
      body.to_json,
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{api_key}"
      }
    )

    # 応答を解析
    if response.is_a?(Net::HTTPSuccess)
      comment = JSON.parse(response.body)["choices"].first["message"]["content"]
      render json: { comment: comment }
    else
      render json: { error: "コメントの生成に失敗しました" }, status: :unprocessable_entity
    end
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
