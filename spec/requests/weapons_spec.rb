require 'rails_helper'

RSpec.describe "Weapons", type: :request do
  describe "GET /weapons" do
    let(:weapons) {  create_list(:weapon, 10) }

    before do
      weapons
      get weapons_path
    end

    it "returns success status" do
      expect(response).to have_http_status(200)  
    end

    it "the weapon's name is present" do
      weapons.each do |weapon|
        expect(response.body).to match(/#{weapon.name}/)
      end
    end

    it 'verifique se os current_power estão sendo exibidos' do
      weapons.each do |weapon|
        expect(response.body).to match(/#{weapon.current_power}/)
      end        
    end

    it "the weapon's title is present" do
      weapons.each do |weapon|
        expect(response.body).to match(/#{weapon.title}/)
      end
    end

    it "the links show and destroy are presents" do
      weapons.each do |weapon|
        expect(response.body).to match(/Show/)
        expect(response.body).to match(/Destroy/)
      end
    end
  end

  describe "POST /weapons" do
    context 'when it has valid parameters' do
      it 'creates the user with correct attributes' do
        weapon_attributes = FactoryBot.attributes_for(:weapon)
        post weapons_path, params: { weapon: weapon_attributes }
        expect(Weapon.last).to have_attributes(weapon_attributes)
      end
    end

    context 'when it has no valid parameters' do
      it 'does not create user' do
        expect{
          post weapons_path, params: {weapon: {name: '', description: '', level: 0, power_base: 0, power_step: 0}}
        }.to_not change(Weapon, :count)
      end
    end
  end

  describe "DELETE /weapons" do
    it 'destroy the weapon' do
      weapon = create(:weapon)
      delete "/weapons/#{weapon.id}"
      expect { weapon.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "GET /weapons/:id" do
    it "show weapon's details" do
      weapon = create(:weapon)
      get "/weapons/#{weapon.id}"
      expect(response.body).to match(/#{weapon.name}/)
      expect(response.body).to match(/#{weapon.description}/)
      expect(response.body).to match(/#{weapon.power_base}/)
      expect(response.body).to match(/#{weapon.power_step}/)
      expect(response.body).to match(/#{weapon.level}/)
    end
  end
end
