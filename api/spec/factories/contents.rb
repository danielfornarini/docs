# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    sequence(:text) { |n| "Text #{n}" }

    association(:document)
  end
end
