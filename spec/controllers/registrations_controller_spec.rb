require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'POST create' do
    let(:params) do
      {
        user: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123' }
      }
    end

    it 'creates an user' do
      expect { post(:create, params:) }.to change(User, :count)
    end

    it 'hashes the password' do
      post(:create, params:)

      expect(User.find_by(email: params[:user][:email]).password_digest).not_to eq(params[:user][:password])
    end

    context 'when passwords do not match' do
      before { params[:user][:password_confirmation] = 'wrong_password' }

      it 'does not create an user' do
        expect { post(:create, params:) }.not_to change(User, :count)
      end
    end

    context 'when password is not safe' do
      before do
        params[:user][:password] = 'wrong_password'
        params[:user][:password_confirmation] = 'wrong_password'
      end

      it 'does not create an user' do
        expect { post(:create, params:) }.not_to change(User, :count)
      end
    end

    context 'when email is already used' do
      before { User.create(params[:user]) }

      it 'does not create an user' do
        expect { post(:create, params:) }.not_to change(User, :count)
      end
    end
  end
end
