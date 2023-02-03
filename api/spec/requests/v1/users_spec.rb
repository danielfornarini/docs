require 'swagger_helper'

RSpec.describe 'V1::Users', type: :request do
  extend UserAuthenticationContext
  include WardenRequestSpecHelper
  include MailerHelpers

  path '/v1/users/{id}' do
    put 'update user' do
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :first_name, in: :formData, type: :string, required: false
      parameter name: :last_name, in: :formData, type: :string, required: false
      parameter name: :password, in: :formData, type: :string, required: false
      parameter name: :password_confirmation, in: :formData, type: :string, required: false
      parameter name: :profile_image, in: :formData, type: :file, required: false
      parameter name: :email, in: :formData, type: :email, required: false

      response '401', 'Unauthorized' do
        let(:id) { create(:user).id }
        let!(:params) {{ }}

        run_test!
      end

      with_authenticated_user do
        response '404', 'user must exist' do
          let!(:id) { -1 }
          let!(:params) {{ }}

          run_test!
        end

        response '403', 'can edit only current user' do
          let!(:id) { create(:user).id }
          let!(:params) {{ }}

          run_test!
        end

        response '200', 'updated user' do
          let!(:id) { user.id }
          let!(:first_name) { 'new_first_name' }
          let!(:last_name) { 'new_last_name' }
          let!(:password) { 'new_password' }
          let!(:password_confirmation) { 'new_password' }
          let!(:profile_image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.png')) }

          run_test! do
            expect(json).to match_structure(data: {
              type: 'users',
              id: user.id.to_s,

              attributes: {
                firstName: 'new_first_name',
                lastName: 'new_last_name',
                profileImage: String
              }
            })
          end
        end

        response '200', 'send confirmation email to new email' do
          let!(:id) { user.id }
          let!(:email) { 'new_email@test.test' }
          let!(:prev_name) { user.email }

          run_test! do
            expect(find_mail_to('new_email@test.test')).to be_truthy
            expect(user.reload.email).to eq(prev_name)
          end
        end

        response '422', 'password_confirmation is mandatory' do
          let!(:id) { user.id }
          let!(:password) { 'new_password' }

          run_test!
        end

        response '422', "password_confirmation doesn't match password" do
          let!(:id) { user.id }
          let!(:password) { 'new_password' }
          let!(:password_confirmation) { 'password' }

          run_test!
        end
      end
    end

    delete 'delete user' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true

      response '401', 'Unauthorized' do
        let!(:id) { create(:user).id }

        run_test!
      end

      with_authenticated_user do
        response '404', 'user must exist' do
          let!(:id) { -1 }

          run_test!
        end

        response '403', 'can delete only current user' do
          let!(:id) { create(:user).id }

          run_test!
        end

        response '200', 'deleted user' do
          let!(:id) { user.id }

          run_test!
        end
      end
    end
  end
end
