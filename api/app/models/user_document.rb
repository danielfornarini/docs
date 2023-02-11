# frozen_string_literal: true

class UserDocument < ApplicationRecord
  belongs_to :user
  belongs_to :document

  validates :permission, presence: true
  validates :document_id, uniqueness: { scope: :user_id }

  enum permission: { read: 0, write: 1 }
end
