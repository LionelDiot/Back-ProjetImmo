# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'
Article.destroy_all
User.destroy_all


ActiveRecord::Base.connection.execute('ALTER SEQUENCE articles_id_seq RESTART WITH 1')
ActiveRecord::Base.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
# Create a user
user = User.create!(
  email: 'admin@admin.fr',
  password: 'password',
  username: 'DB/seed'
)

# Create articles associated with the user
10.times do
  user.articles.create!(
    title: Faker::Commerce.product_name,
    content: Faker::Lorem.paragraph
  )
end

puts 'Seed réussi!'
