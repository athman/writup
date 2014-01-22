namespace :db do
  desc "fill database with data"
  task populate: :environment do
    User.create!(first_name: "Athman", surname: "Gude", email: "athmangude@gmail.com", password: "secretword", password_confirmation: "secretword", admin: true)
    99.times do |n|
      first_name = Faker::Name.first_name
      surname = Faker::Name.last_name
      email = Faker::Internet.email(first_name+surname)
      password = "secretword"
      password_confirmation = "secretword"
      User.create!(first_name: first_name, surname: surname, email: email, password: password, password_confirmation: password_confirmation)
    end
  end
end