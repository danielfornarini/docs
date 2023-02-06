# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document, type: :model do
  validate_associations!
  check_validations!

  it 'should return contents that the user can read' do
    user = create(:user)
    create(:document, owner: user)
    create(:user_document, user: user, permission: :write)
    create(:user_document, user: user, permission: :read)
    create_list(:user_document, 5)

    expect(Content.of_reader_user_id(user.id).count).to eq(3)
  end

  it 'should return contents that the user can edit' do
    user = create(:user)
    create(:document, owner: user)
    create(:user_document, user: user, permission: :write)
    create(:user_document, user: user, permission: :read)
    create_list(:user_document, 5)

    expect(Content.of_writer_user_id(user.id).count).to eq(2)
  end

  it 'should return contents owned by the user' do
    user = create(:user)
    create(:document, owner: user)
    create(:user_document, user: user, permission: :write)
    create(:user_document, user: user, permission: :read)
    create_list(:user_document, 5)

    expect(Content.of_owner_user_id(user.id).count).to eq(1)
  end

  it 'create up to 10 versions' do
    content = create(:content)

    content.update(text: '0')
    content.update(text: '1')
    content.update(text: '2')
    content.update(text: '3')
    content.update(text: '4')
    content.update(text: '5')
    content.update(text: '6')
    content.update(text: '7')
    content.update(text: '8')
    content.update(text: '9')
    content.update(text: '10')
    content.update(text: '11')

    expect(content.versions.count).to eq(10)
    expect(content.versions.first.object['text']).to eq('1')
    expect(content.versions.last.object['text']).to eq('10')
  end
end
