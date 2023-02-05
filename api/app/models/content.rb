class Content < ApplicationRecord
  belongs_to :document

  validates :text, presence: true, allow_blank: true

  has_paper_trail
end
