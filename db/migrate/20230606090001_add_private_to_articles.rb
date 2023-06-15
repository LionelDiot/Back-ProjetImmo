class AddPrivateToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :isPrivate, :boolean, default: false, null: false
  end
end
