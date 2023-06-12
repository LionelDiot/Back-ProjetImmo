class AddPrivateToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :private, :boolean, default: false, null: false
  end
end
