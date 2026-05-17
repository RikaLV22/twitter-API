class Likes_controller < ApplicationController
  before_action :authenticate_user!

  def create
    tweet = Tweet.find(params[:tweet_id])
    like = tweet.likes.build(user: current_user)

    if like.save
      render json: { message: "いいねしました" }
    else
      render json: { error: "いいね出来ませんでした" }, status: :unprocessable_entity
    end
  end

  def destroy
    tweet = Tweet.find(params[:tweet_id])
    like = tweet.likes.find_by(user: current_user)

    like.destroy if like

    render json: { message: "いいねを取り消しました" }
  end
end