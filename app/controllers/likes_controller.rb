class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    tweet = Tweet.find(params[:tweet_id])
    like = tweet.likes.find_or_initialize_by(user: current_user)

    like.save!

    render json: {
      likes_count: tweet.likes.count,
      liked: true
    }
  end

  def destroy
    tweet = Tweet.find(params[:tweet_id])
    like = tweet.likes.find_by(user: current_user)

    like&.destroy

    render json: {
      likes_count: tweet.likes.count,
      liked: false
    }
  end
end