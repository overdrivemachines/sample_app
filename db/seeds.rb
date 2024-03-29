# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create a main sample user.
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Generate microposts for a subset of users.
# User.order(:created_at).take(6).each do |user|
#   50.times do
#     post = user.microposts.create!(content: Faker::Quote.jack_handey[0..139])
#   end
# end
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Quote.jack_handey[0..139]
  users.each { |user| user.microposts.create!(content: content) }
end

# Second user is followed by 5 random followers
# user = User.second
# Relationship.create(follower_id: User.all[rand(0..(User.count - 1))].id, followed_id: user.id)
# Relationship.create(follower_id: User.all[rand(0..(User.count - 1))].id, followed_id: user.id)
# Relationship.create(follower_id: User.all[rand(0..(User.count - 1))].id, followed_id: user.id)
# Relationship.create(follower_id: User.all[rand(0..(User.count - 1))].id, followed_id: user.id)
# Relationship.create(follower_id: User.all[rand(0..(User.count - 1))].id, followed_id: user.id)

# The first user follows users 3 through 51, and then
# users 4 through 41 follow that user back.
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
