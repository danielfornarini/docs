
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDocument, type: :model do
  validate_associations!
  check_validations!

  it 'should validate uniqueness off user_id and document_id' do
    document = create(:document)
    user = create(:user)
    create(:user_document, user: user, document: document)

    user_document = create(:user_document)
    user_document.user = user
    user_document.document = document
    user_document.save

    expect(user_document).to have(1).errors_on(:document_id)
  end
end
