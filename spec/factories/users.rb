FactoryGirl.define do
  factory :user do
    sequence(:login) {|n| "user#{n}" }
    sequence(:email) {|n| "user#{n}@example.com" }
    password "user1234"
    association :tenant

    factory :user_admin, :class => User do
      roles {|roles| [roles.association(:admin_role)] }
    end
  end
end

