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
  
  factory :post do
    content "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec mi lacus, accumsan ut magna at, eleifend auctor arcu. Mauris varius ipsum eget suscipit ultricies. Pellentesque felis quam, sagittis quis elit nec, commodo facilisis velit. Nam vitae faucibus ipsum. Nullam ut dolor tincidunt, sodales mi sed, cursus elit. Nunc convallis purus tempor lorem tristique faucibus. Nam arcu magna, pellentesque in risus sed, laoreet iaculis diam. Proin hendrerit, eros sit amet tristique semper, urna lectus blandit lorem, quis venenatis nisi neque non ante. Proin nec molestie elit. Mauris tristique tristique nisl ac pellentesque. In vel metus tortor. Quisque quis commodo mi."
    user
  end
  
end