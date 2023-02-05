FactoryBot.define do
  factory :user_document do
    association :user
    association :document

    permission { :read }
  end
end
