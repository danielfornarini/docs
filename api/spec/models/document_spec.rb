# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document, type: :model do
  validate_associations!
  check_validations!

  it 'should create content on document creation' do
    document = create(:document)

    expect(document.content).not_to be(nil)
  end

  it 'should return documents that the user can read' do
    user = create(:user)
    create(:document, owner: user)
    create(:user_document, user: user, permission: :write)
    create(:user_document, user: user, permission: :read)
    create_list(:user_document, 5)

    expect(Document.of_reader_user_id(user.id).count).to eq(3)
  end

  it 'should return documents that the user can edit' do
    user = create(:user)
    create(:document, owner: user)
    create(:user_document, user: user, permission: :write)
    create(:user_document, user: user, permission: :read)
    create_list(:user_document, 5)

    expect(Document.of_writer_user_id(user.id).count).to eq(2)
  end

  it 'should return documents owned by the user' do
    user = create(:user)
    create(:document, owner: user)
    create(:user_document, user: user, permission: :write)
    create(:user_document, user: user, permission: :read)
    create_list(:user_document, 5)

    expect(Document.of_owner_user_id(user.id).count).to eq(1)
  end
end
