require 'rails_helper'

RSpec.describe ReportsController do
  describe 'GET index' do
    it 'displays for manager' do
      user = FactoryGirl.create :user, role: :manager
      sign_in user

      get :index
      check_index_page(response)
    end

    it 'displays for admin' do
      user = FactoryGirl.create :user, role: :admin
      sign_in user

      get :index
      check_index_page(response)
    end

    it 'should redirect to sign_in when not logged in' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not be accessible by user' do
      user = FactoryGirl.create :user
      sign_in user

      expect { get :index }.to raise_error CanCan::AccessDenied
    end

    private

    def check_index_page(response)
      expect(response).to render_template(:index)
      expect(assigns(:date_from)).to be_a(Time)
      expect(assigns(:date_to)).to be_a(Time)
    end
  end
end
