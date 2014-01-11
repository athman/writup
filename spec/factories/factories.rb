FactoryGirl.define do
  factory :user do
    first_name              "Siti"
    surname                 "Paku"
    email                   "sitipaku@gmail.com"
    password                "secretword"
    password_confirmation   "secretword"
  end
end