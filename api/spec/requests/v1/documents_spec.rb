require 'swagger_helper'

RSpec.describe 'V1::Documents', type: :request do
  extend UserAuthenticationContext
  include WardenRequestSpecHelper

  path '/v1/documents' do
    get 'list documents' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      response '401', 'Unauthorized' do
        run_test!
      end

      with_authenticated_user do
        response '200', 'returns all documents accessible by current user' do
          before(:each) do
            create(:document, owner: user)
            create(:user_document, permission: :read, user: user)
            create(:user_document, permission: :write, user: user)
            create_list(:user_document, 5)
          end

          run_test! do
            expect(json).to match_structure(data: a_list_of(
              {
                id: String,
                type: 'documents',
                attributes: {
                  title: String,
                  contentId: Integer,
                  createdAt: String,
                  updatedAt: String
                },
                relationships: {
                  owner: {
                    data: {
                      id: String,
                      type: 'users'
                    }
                  }
                }
              }).with(3).elements)
          end
        end

        response '200', 'return paginated documents' do
          let!(:documents) { create_list(:document, 30, owner: user) }

          run_test! do
            expect(json.dig('data').count).to eq(20)
          end
        end
      end
    end

    post 'create document' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          owner_id: { type: :integer }
        }
      }

      response '401', 'Unauthorized' do
        let!(:params) { { title: 'new_document_title' } }
        let!(:params) { {} }

        run_test!
      end

      with_authenticated_user do
        response '422', 'missing required parameters' do
          let!(:params) { {} }

          run_test!
        end

        response '200', 'creates document' do
          let!(:params) { { title: 'new_document_title' } }

          run_test! do
            expect(json).to match_structure(data: {
              id: String,
              type: 'documents',
              attributes: {
                title: 'new_document_title',
                contentId: Integer,
              },
              relationships: {
                owner: {
                  data: {
                    id: user.id.to_s,
                    type: 'users'
                  }
                }
              }
            })
          end
        end
      end
    end
  end

  path '/v1/documents/{id}' do
    get 'gets document' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true

      response '401', 'Unauthorized' do
        let!(:id) { 1 }

        run_test!
      end

      with_authenticated_user do
        response '404', 'document must exist' do
          let!(:id) { -1 }

          run_test!
        end

        response '403', 'user must have read permissions the document' do
          let!(:document) { create(:document) }
          let!(:id) { document.id }

          run_test!
        end

        response '200', 'returns document' do
          let!(:user_document) { create(:user_document, user: user, permission: :read) }
          let!(:document) { user_document.document }
          let!(:id) { document.id }

          run_test! do
            expect(json).to match_structure(data: {
              id: id.to_s,
              type: 'documents',
              attributes: {
                title: document.title,
                contentId: Integer,
              },
              relationships: {
                owner: {
                  data: {
                    id: document.owner.id.to_s,
                    type: 'users'
                  }
                }
              }
            })
          end
        end
      end
    end

    put 'updates document' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        }
      }

      response '401', 'Unauthorized' do
        let!(:id) { 1 }
        let!(:params) { {} }

        run_test!
      end

      with_authenticated_user do
        response '404', 'document must exist' do
          let!(:id) { 1 }
          let!(:params) { {} }

          run_test!
        end

        response '403', 'user must have write permission to update the document' do
          let!(:user_document) { create(:user_document, permission: :read, user: user) }
          let!(:id) { user_document.document.id }
          let!(:params) { { title: 'new_updated_title' } }

          run_test!
        end

        response '200', 'updates document' do
          let!(:user_document) { create(:user_document, permission: :write, user: user) }
          let!(:id) { user_document.document.id }
          let!(:params) { { title: 'new_updated_title' } }

          run_test! do
            expect(json).to match_structure(data: {
              id: id.to_s,
              type: 'documents',
              attributes: {
                title: 'new_updated_title',
                contentId: Integer,
              },
            })
          end
        end
      end
    end

    delete 'deletes document' do
      consumes 'application/json', 'application/x-www-form-urlencoded'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, required: true

      response '401', 'Unauthorized' do
        let!(:id) { 1 }
        let!(:params) { {} }

        run_test!
      end

      with_authenticated_user do
        response '404', 'document must exist' do
          let!(:id) { 1 }
          let!(:params) { {} }

          run_test!
        end

        response '403', 'user must be the owner to destroy the document' do
          let!(:user_document) { create(:user_document, permission: :write, user: user) }
          let!(:id) { user_document.document.id }

          run_test!
        end

        response '200', 'deletes document' do
          let!(:document) { create(:document, owner: user) }
          let!(:id) { document.id }

          run_test!
        end
      end
    end
  end
end
