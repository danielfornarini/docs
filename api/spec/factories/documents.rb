# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    sequence(:title) { |n| "Document title #{n}" }
  end
end
