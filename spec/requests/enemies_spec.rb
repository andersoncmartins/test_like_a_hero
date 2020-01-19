require 'rails_helper'

RSpec.describe "Enemies", type: :request do
  describe 'GET /enemies' do
    it "return status code 200" do
      get enemies_path
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /enemies" do
    context 'when the enemy exist' do
      let(:enemy) { create(:enemy) }
      let(:enemy_attributes) { attributes_for(:enemy) }

      before(:each) { put "/enemies/#{enemy.id}", params: enemy_attributes }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the enemy' do
        expect(enemy.reload).to have_attributes(enemy_attributes)
      end

      it 'returns the enemy updated' do
        expect(enemy.reload).to have_attributes(json.except('created_at', 'updated_at'))
      end
    end

    context 'when the enemy does not exist' do
      before(:each) { put '/enemies/0', params: attributes_for(:enemy) }

      it 'return status code 404' do
        expect(response).to have_http_status(404)  
      end

      it 'returns a not found message ' do
        expect(response.body).to match(/Couldn't find Enemy/)  
      end
    end
  end

  describe 'DELETE /enemies' do
    context 'when the enemy exist' do
      let(:enemy) { create(:enemy) }
      before(:each) { delete "/enemies/#{enemy.id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'destroy the enemy' do
        expect { enemy.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when the enemy does not exist' do
      before(:each) { delete '/enemies/0' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end

  describe 'SHOW /enemies/:id' do
    let(:enemy) { create(:enemy) }
    before(:each) { get "/enemies/#{enemy.id}" }

    context 'when the enemy exist' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the enemy' do
        expect(enemy.reload).to have_attributes(json.except('name', 'power_base', 'power_step', 'level', 'kind', 'created_at', 'updated_at'))
      end
    end

    context 'when the enemy does not exist' do
      before(:each) { get '/enemies/0' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Enemy/)
      end
    end
  end

  describe 'POST /enemies/' do
    let(:enemy) { create(:enemy) }
    let(:enemy_attributes) { attributes_for(:enemy) }

    before(:each) { post '/enemies/', params: enemy_attributes }

    context 'should save' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the enemy' do
        expect(enemy.reload).to have_attributes(json.except('id', 'name', 'power_base', 'power_step', 'level', 'kind', 'created_at', 'updated_at'))
      end
    end

    context "shouldn't save" do
      let(:enemy) { build(:enemy, name: '', level: '', power_base: '', power_step: '', kind: '') } 
      before(:each) { post '/enemies/', params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should show raise errors' do
        enemy.save
        expect(enemy.errors.count).to be > 0
      end
    end
  end
end
