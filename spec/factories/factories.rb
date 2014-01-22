#FactoryGirl.define do
#  factory :user do
#    first_name              "Siti"
#    surname                 "Paku"
#    email                   "sitipaku@gmail.com"
#    password                "secretword"
#    password_confirmation   "secretword"
#  end
#end

FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Person #{n}" }
    sequence(:surname) { |n| "Name #{n}"}
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "secretword"
    password_confirmation "secretword"
    
    factory :admin do
      admin true
    end
    
  end
end