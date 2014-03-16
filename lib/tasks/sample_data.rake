namespace :db do
  desc "fill database with data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(first_name: "Athman", surname: "Gude", email: "athmangude@gmail.com", password: "secretword", password_confirmation: "secretword", admin: true)
  99.times do |n|
    first_name = Faker::Name.first_name
    surname = Faker::Name.last_name
    email = Faker::Internet.email(first_name+surname)
    password = "secretword"
    password_confirmation = "secretword"
    User.create!(first_name: first_name, surname: surname, email: email, password: password, password_confirmation: password_confirmation)      
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    title = "Lorem Ipsum Dolor Sit Amet"
    content = Faker::Lorem.paragraph(100)
    users.each {|user| user.posts.create!(title: title, content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each {|followed_user| user.follow!(followed_user) }
  followers.each {|follower| follower.follow!(user) }
end
