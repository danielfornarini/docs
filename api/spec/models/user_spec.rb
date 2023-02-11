require 'rails_helper'

RSpec.describe User, type: :model do
  check_validations!
  validate_associations!

  it 'should validate password token' do
    user = create(:user)
    user.reset_password_sent_at = Time.now.utc - 5.hours
    user.save

    expect(user.password_token_valid?).to eq(false)
  end

  it 'should rest password' do
    user = create(:user)
    user.reset_password!('TestPassword1234.', 'TestPassword1234.')

    expect(user.password).to eq('TestPassword1234.')
  end

  it 'should check for confirmation_password presence when updating password' do
    user = create(:user)
    user.password = 'NewPassword1234!'
    user.save

    expect(user).to have_at_least(1).errors_on(:password_confirmation)

    user.password = 'NewPassword1234!'
    user.password_confirmation = 'NewPassword1234!'
    user.save

    expect(user).to have(0).errors_on(:password_confirmation)
  end
end
