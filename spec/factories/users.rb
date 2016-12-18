FactoryGirl.define do
  factory :user do
    name 'Peter Parker'
    email 'iamnotspiderman@parker.com'
    password 'MyPassword1'
    password_confirmation 'MyPassword1'
    activated true
    activated_at Time.zone.now

    factory :empty_user do
      name ''
      email ''
    end

    factory :invalid_password do
      password 'password1'
      password_confirmation 'password1'
    end
  end
end
