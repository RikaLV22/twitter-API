class AddParentTweetToTweets < ActiveRecord::Migration[8.1]
  def change
    add_column :tweets, :parent_tweet_id, :integer
    add_index :tweets, :parent_tweet_id
  end
end
