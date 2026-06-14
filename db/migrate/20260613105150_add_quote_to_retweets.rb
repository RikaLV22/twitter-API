class AddQuoteToRetweets < ActiveRecord::Migration[8.1]
  def change
    add_column :retweets, :comment, :text
  end
end
