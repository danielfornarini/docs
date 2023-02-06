require 'swagger_helper'

RSpec.describe 'V1::Contents', type: :request do
  extend UserAuthenticationContext
  include WardenRequestSpecHelper

  path '/v1/contents/{id}' do
    get 'load content' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true

      response '401', 'Unauthorized' do
        let!(:id) { 1 }
        run_test!
      end

      with_authenticated_user do
        response '403', 'user must have read permissions to read the content' do
          let!(:document) { create(:document) }
          let!(:id) { document.content.id }

          run_test!
        end

        response '200', 'returns the content' do
          let!(:user_document) { create(:user_document, user: user, permission: :read) }
          let!(:id) { user_document.document.content.id }

          run_test! do
            expect(json).to match_structure(data: {
              id: id.to_s,
              type: 'contents',
              attributes: {
                text: String,
                documentId: user_document.document.id
              }
            })
          end
        end
      end
    end

    put 'updates content' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'


      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          text: { type: :string }
        }
      }

      response '401', 'Unauthorized' do
        let!(:id) { 1 }
        let!(:params) { {} }
        run_test!
      end

      with_authenticated_user do
        response '403', 'user must have write permissions to update the content' do
          let!(:user_document) { create(:user_document, user: user, permission: :read) }
          let!(:id) { user_document.document.content.id }
          let!(:params) { { text: 'updated_text' } }

          run_test!
        end

        response '200', 'updates the content' do
          let!(:user_document) { create(:user_document, user: user, permission: :write) }
          let!(:id) { user_document.document.content.id }
          let!(:params) { { text: 'updated_text' } }

          run_test! do
            expect(json).to match_structure(data: {
              id: id.to_s,
              type: 'contents',
              attributes: {
                text: 'updated_text',
                documentId: user_document.document.id
              }
            })
          end
        end
      end
    end
  end

  path '/v1/contents/{id}/versions' do
    get 'load content versions' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true

      response '401', 'Unauthorized' do
        let!(:id) { 1 }
        run_test!
      end

      with_authenticated_user do
        response '403', 'user must have read permissions to read content versions' do
          let!(:document) { create(:document) }
          let!(:id) { document.content.id }
          let!(:params) { { text: 'updated_text' } }

          run_test!
        end

        response '200', 'returns content versions' do
          before(:each) do
            document = create(:document, owner: user)
            content = document.content

            PaperTrail.request.whodunnit = user.id
            content.update(text: '0')
            content.update(text: '1')
            content.update(text: '2')
          end

          let!(:id) { Content.last.id }

          run_test! do
            expect(json).to match_structure(data: a_list_of(
              {
                id: String,
                type: 'contentVersions',
                attributes: {
                  content: {
                    documentId: Integer,
                    text: String,
                    id: Integer,
                    createdAt: String,
                    updatedAt: String
                  },
                  createdAt: String
                },
                relationships: {
                  user: {
                    data: {
                      id: user.id.to_s,
                      type: 'users'
                    }
                  }
                }
              }
            ).with(3).elements)
          end
        end
      end
    end
  end
end
