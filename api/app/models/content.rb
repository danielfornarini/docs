class Content < ApplicationRecord
  belongs_to :document

  validates :text, presence: true, allow_blank: true

  has_paper_trail on: [:update], limit: 10

  scope :of_owner_user_id, lambda { |user_id|
    where(document_id:  Document.of_owner_user_id(user_id))
  }

  scope :of_reader_user_id, lambda { |user_id|
    where(document_id: Document.of_reader_user_id(user_id))
  }

  scope :of_writer_user_id, lambda { |user_id|
    where(document_id: Document.of_writer_user_id(user_id))
  }
end
