class RetweetsController < ApplicationController
  before_action :authenticate_user!

  def create
    tweet = Tweet.find(params[:tweet_id])

    retweet = Retweet.find_or_initialize_by(
      user_id: current_user.id,
      tweet_id: tweet.id
    )

    retweet.comment = params[:comment] if params[:comment].present?
    retweet.save!

    render json: {
      retweets_count: tweet.retweets.count,
      retweeted: true
    }
  end

  def destroy
    tweet = Tweet.find(params[:tweet_id])

    retweet = Retweet.find_by(
      user_id: current_user.id,
      tweet_id: tweet.id
    )

    retweet&.destroy

    render json: {
      retweets_count: tweet.retweets.count,
      retweeted: false
    }
  end
end