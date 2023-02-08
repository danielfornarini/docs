require 'swagger_helper'

RSpec.describe 'V1::Auth::Passwords', type: :request do
  include MailerHelpers

  path '/v1/auth/password/forgot' do
    post 'forgot password' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        }
      }

      response '200', 'sent forgot password' do
        let!(:user) { create(:user) }
        let!(:params) { { email: user.email } }

        run_test! do
          expect(find_mail_to(user.email)).to be_truthy
        end
      end

      response '404', 'wrong email' do
        let!(:params) { { email: '-1' } }

        run_test!
      end
    end
  end

  path '/v1/auth/password/reset' do
    post 'reset password' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        }
      }

      let!(:user) { create(:user) }
      before(:each) do
        user.send_reset_password_instructions
      end

      response '200', 'correctly resetted password' do
        let!(:params) {{ token: user.reset_password_token, password: 'NewPassword1234.', password_confirmation: 'NewPassword1234.' }}
        let!(:user_encrypted_password) { user.encrypted_password }

        run_test! do
          expect(user.reload.reset_password_token).to eq(nil)
          expect(user.reload.encrypted_password).not_to eq(user_encrypted_password)
        end
      end

      response '422', 'password_confirmation mandatory' do
        let!(:params) {{ token: user.reset_password_token, password: 'NewPassword1234.' }}

        run_test!
      end

      response '422', "password_confirmation doesn't match password" do
        let!(:params) {{ token: user.reset_password_token, password: 'NewPassword1234.', password_confirmation: 'test' }}
        let!(:user_encrypted_password) { user.encrypted_password }

        run_test! do
          expect(user.reload.encrypted_password).to eq(user_encrypted_password)
        end
      end
    end
  end
end
