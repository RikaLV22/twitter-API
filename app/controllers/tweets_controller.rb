class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def index
    tweets = Tweet.where(parent_tweet_id: nil).includes(:user, :likes).order(created_at: :desc)

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
        replies_count: tweet.replies.count,
        liked: current_user ? tweet.likes.exists?(user: current_user) : false
      }
    }
  end

  def show
    tweet = Tweet.includes(replies: :user, user: {}, likes: {}).find(params[:id])

    render json: {
      id: tweet.id,
      body: tweet.body,
      user: {
        id: tweet.user.id,
        name: tweet.user.username,
        username: tweet.user.username
      },
      likes_count: tweet.likes.count,
      replies_count: tweet.replies.count,
      liked: current_user ? tweet.likes.exists?(user: current_user) : false,

      replies: tweet.replies.map { |r|
        {
          id: r.id,
          body: r.body,
          user: {
            id: r.user.id,
            name: r.user.username,
            username: r.user.username
          }
        }
      }
    }
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

    reply = current_user.tweets.create!(
      body: params.require(:tweet)[:body],
      parent_tweet_id: parent.id
    )

    render json: {
      id: reply.id,
      body: reply.body,
      user: {
        id: reply.user.id,
        name: reply.user.username,
        username: reply.user.username
      }
    }
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