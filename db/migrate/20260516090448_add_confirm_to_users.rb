class AddConfirmToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :confirmed, :boolean
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
  end
end
