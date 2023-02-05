class Document < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: :owned_documents
  has_many :user_documents, dependent: :destroy
  has_many :users, through: :user_documents
  has_one :content, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :user_documents

  after_create do
    Content.create!(document: self)
  end

  as_queryable
  queryable order: { updated_at: :asc }, filter: [], per: 20

  scope :of_owner_user_id, lambda { |user_id|
    where({ owner_id: user_id })
  }

  scope :of_reader_user_id, lambda { |user_id|
    user_document_table = UserDocument.arel_table

    left_joins(:user_documents)
      .of_owner_user_id(user_id)
      .or(
        where(
          user_document_table[:user_id].eq(user_id)
        )
      )
  }

  scope :of_writer_user_id, lambda { |user_id|
    user_document_table = UserDocument.arel_table

    left_joins(:user_documents)
      .of_owner_user_id(user_id)
      .or(
        where(
          user_document_table[:user_id]
            .eq(user_id)
            .and(user_document_table[:permission].eq(:write))
        )
      )
  }
end
