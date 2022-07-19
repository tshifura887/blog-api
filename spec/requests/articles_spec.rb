require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let(:user) { create(:user)}
  let!(:articles) { create_list(:article, 10, user_id: user.id)}
  let(:article_id) { articles.first.id}
  let(:headers) { valid_headers}

  describe 'GET /articles' do
    before {get '/articles', params: {}, headers: headers}

    context 'when request is valid' do
      
      it 'returns articles' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /aricles/:id' do
    before { get "/articles/#{article_id}", params: {}, headers: headers}

    context 'when record exists'  do

      it 'returns an article' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(article_id)
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      let(:article_id) { 100 }

      it 'returns http status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Couldn't find Article/)
      end
    end
  end

  describe 'POST /articles' do
    let(:valid_attributes) {{ title: 'The most wonderful day of the year'}.to_json}

    context 'when valid request' do
      before { post '/articles', params: valid_attributes, headers: headers}

      it 'creates an article' do
        expect(json['title']).to eq('The most wonderful day of the year')
      end

      it 'returns http status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when invalid request' do
      before {post '/articles', params: {}, headers: headers}

      it 'returns http status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /articles/:id' do
    let(:valid_attributes) {{ title: 'The most wonderful day if the month'}.to_json}

    context 'when record exists' do
      before { put "/articles/#{article_id}", params: valid_attributes, headers: headers}

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /articles/:id' do
    before { delete "/articles/#{article_id}", params: {}, headers: headers}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
