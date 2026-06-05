class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def index
    tweets = Tweet.includes(:user).order(created_at: :desc)
    
    render json: tweets.map { |tweet|
      {
        id: tweet.id,
        body: tweet.body,
        user: {
          id: tweet.user.id,
          name: tweet.user.username,
          username: tweet.user.username
        },
        likes_count: tweet.likes.count,
        liked: current_user ? tweet.likes.exists?(user: current_user) : false
      }
    }
  end

  def show
    tweet = Tweet.find(params[:id])
    render json: tweet, include: :user
  end

  def create
    
    tweet = current_user.tweets.build(tweet_params)

    if tweet.save
      render json: tweet, include: :user, status: :created
    else
      render json: { errors: tweet.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def reply
    parent = Tweet.find(params[:id])

    tweet = current_user.tweets.build(
      body: params[:body],
      parent_tweet_id: parent.id
    )

    if tweet.save
      render json: tweet, include: :user
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end

  end

  def destroy
    tweet = current_user.tweets.find(params[:id])
    tweet.destroy

    render json: { message:"ツイートを削除しました" }
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body)
  end
end