# Dockerfile
FROM ruby:3.0.4

# 以下はそのまま
RUN apt-get update -qq && apt-get install -y nodejs npm && npm install -g yarn
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]