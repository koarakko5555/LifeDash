FROM ruby:3.0.4

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y nodejs npm && npm install -g yarn

# 再発防止: UIDとGIDを指定してグループとユーザーを作成
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID hosayan1016 && \
    useradd -m -u $UID -g $GID hosayan1016

# 作業ディレクトリを設定
WORKDIR /app

# ファイルをコピーし、依存関係をインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションのコードをコンテナにコピー
COPY . .

# ポートを公開
EXPOSE 3000

# 非rootユーザーに切り替え
USER hosayan1016

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
