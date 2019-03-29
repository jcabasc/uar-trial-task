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
              tags: %w[tag1 tag2]
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
        let(:tags) { %w[tag1 tag2] }
        it 'responds with bad request error' do
          post '/api/v1/files', params: params.to_json, headers: {}
          expect(response.status).to eq 400
          expect(response.success?).to eq false
        end
      end
      context 'when validation error' do
        let(:tags) { %w[+tag1 -tag2] }
        it 'responds with validation error' do
          post '/api/v1/files', params: params.to_json, headers: headers
          expect(response.status).to eq 422
          expect(response.success?).to eq false
        end
      end
    end
  end

  describe '#index' do
    before do
      create(:custom_file, name: 'file1', tags: %w[tag1 tag2 tag3 tag5])
      create(:custom_file, name: 'file2', tags: %w[tag2])
      create(:custom_file, name: 'file3', tags: %w[tag2 tag3 tag5])
      create(:custom_file, name: 'file4', tags: %w[tag2 tag3 tag4 tag5])
      create(:custom_file, name: 'file5', tags: %w[tag3 tag4])
    end

    context 'success' do
      before do
        allow(CustomFile).to receive(:per_page) { 1 }
      end
      it 'responds successfully with the file in the first page' do
        get '/api/v1/files/+tag2%20+tag3%20-tag4/1',
            params: {},
            headers: headers
        response_body = JSON.parse(response.body)
        data = response_body.dig('data')
        expect(response.status).to eq 200
        expect(response.success?).to eq true
        expect(data.count).to eq(1)
        expect(data[0].dig('attributes', 'name')).to eq('file1')
      end

      it 'responds successfully with the file in the second page' do
        get '/api/v1/files/+tag2%20+tag3%20-tag4/2',
            params: {},
            headers: headers
        response_body = JSON.parse(response.body)
        data = response_body.dig('data')
        expect(data.count).to eq(1)
        expect(data[0].dig('attributes', 'name')).to eq('file3')
      end

      it 'responds successfully with an empty array' do
        get '/api/v1/files/+tag2%20+tag3%20-tag4/3',
            params: {},
            headers: headers
        response_body = JSON.parse(response.body)
        data = response_body.dig('data')
        expect(response.status).to eq 200
        expect(data.count).to eq(0)
      end
    end
  end
end
