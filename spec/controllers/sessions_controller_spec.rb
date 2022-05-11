require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST create' do
    let(:params) do
      {
        email: 'test@example.com',
        password: 'password123'
      }
    end

    let!(:user) { create(:user) }

    it 'logins user' do
      post(:create, params:)

      expect(session[:user_id]).to eq(user.id)
    end

    context 'when passwords do not match' do
      before { params[:password] = 'wrong_password' }

      it 'does not create an user' do
        post(:create, params:)

        expect(session[:user_id]).to eq(nil)
      end
    end
  end
end
