class Document < ApplicationRecord
  validates :title, presence: true

  has_one :content, dependent: :destroy
end
