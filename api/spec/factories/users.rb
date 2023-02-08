FactoryBot.define do
  factory :user do
    sequence(:first_name) { |i| "first_name #{i}" }
    sequence(:last_name) { |i| "last_name #{i}" }
    sequence(:email) { |i| "email#{i}@test.test" }
    password { 'Password1234.' }
    password_confirmation { 'Password1234.' }
  end
end
