require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  describe 'PATCH update' do
    let(:new_password) { 'new_password123' }
    let(:params) do
      {
        user: { password: new_password, password_confirmation: new_password }
      }
    end

    let!(:user) { create(:user) }

    before { session[:user_id] = user.id }

    it 'updates password' do
      patch(:update, params:)

      expect(user.reload.authenticate(new_password)).to eq(user)
    end

    context 'when passwords do not match' do
      before { params[:user][:password_confirmation] = 'wrong_password' }

      it 'does not create an user' do
        patch(:update, params:)

        expect(user.reload.authenticate(new_password)).to eq(false)
      end
    end
  end
end
