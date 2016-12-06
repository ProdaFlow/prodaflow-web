FactoryGirl.define do
  factory :user do
    name "Peter Parker"
    email "iamnotspiderman@parker.com"

    factory :empty_user do
      name ""
      email ""
    end
  end
end
