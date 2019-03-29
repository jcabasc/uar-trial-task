# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Files', type: :request do
  describe '#create' do
    context 'success' do
      let(:params) do
        {
          data: {
            type: 'files',
            attributes: {
              name: 'custom',
              tags: ['tag1', 'tag2']
            }
          }
        }
      end
      let(:headers) do
        {
          'Content-Type': 'application/json'
        }
      end

      it 'responds successfully' do
        post '/api/v1/files', params: params.to_json, headers: headers
        expect(response.status).to eq 200
        expect(response.success?).to eq true
      end
    end

    context 'failure' do
      let(:params) do
        {
          data: {
            type: 'files',
            attributes: {
              name: 'custom',
              tags: tags
            }
          }
        }
      end
      let(:headers) do
        {
          'Content-Type': 'application/json'
        }
      end
      context 'when bad request' do
        let(:tags) { ['tag1', 'tag2'] }
        it 'responds with bad request error' do
          post '/api/v1/files', params: params.to_json, headers: {}
          expect(response.status).to eq 400
          expect(response.success?).to eq false
        end
      end
      context 'when validation error' do
        let(:tags) { ['tag1+', 'tag2-'] }
        it 'responds with validation error' do
          post '/api/v1/files', params: params.to_json, headers:headers
          expect(response.status).to eq 422
          expect(response.success?).to eq false
        end
      end
    end
  end
end