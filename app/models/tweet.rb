class Tweet < ApplicationRecord
  belongs_to :user
  
  belongs_to :parent_tweet,
              class_name: "Tweet",
              foreign_key: "Parent_tweet_id",
              optional: true

  has_many :replies,
            class_name: "Tweet",
            foreign_key: "parent_tweet_id",
            dependent: :destroy
end
