require 'rails_helper'

RSpec.describe BooksController do
  describe 'GET index' do
    it 'displays for manager' do
      user = FactoryGirl.create :user, role: :manager
      sign_in user

      get :index
      expect(response).to render_template(:index)
    end

    it 'displays for admin' do
      user = FactoryGirl.create :user, role: :admin
      sign_in user

      get :index
      expect(response).to render_template(:index)
    end

    it 'displays for user' do
      user = FactoryGirl.create :user
      sign_in user

      get :index
      expect(response).to render_template(:index)
    end

    it 'should redirect to sign_in when not logged in' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET show' do
    it 'displays for manager' do
      book = FactoryGirl.create :book
      user = FactoryGirl.create :user, role: :manager
      sign_in user

      get :show, { id: book.id }
      expect(response).to render_template(:show)
    end

    it 'displays for admin' do
      book = FactoryGirl.create :book
      user = FactoryGirl.create :user, role: :admin
      sign_in user

      get :show, { id: book.id }
      expect(response).to render_template(:show)
    end

    it 'displays for user' do
      book = FactoryGirl.create :book
      user = FactoryGirl.create :user
      sign_in user

      get :show, { id: book.id }
      expect(response).to render_template(:show)
    end

    it 'should redirect to sign_in when not logged in' do
      book = FactoryGirl.create :book

      get :show, { id: book.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET edit' do
    it 'displays for manager' do
      book = FactoryGirl.create :book
      user = FactoryGirl.create :user, role: :manager
      sign_in user

      get :edit, { id: book.id }
      expect(response).to render_template(:edit)
    end

    it 'displays for admin' do
      book = FactoryGirl.create :book
      user = FactoryGirl.create :user, role: :admin
      sign_in user

      get :edit, { id: book.id }
      expect(response).to render_template(:edit)
    end

    it 'should not display for user (now owner)' do
      book = FactoryGirl.create :book
      user = FactoryGirl.create :user
      sign_in user

      expect { get :edit, { id: book.id } }.to raise_error(CanCan::AccessDenied)
    end

    it 'should display for user (owner)' do
      user = FactoryGirl.create :user
      book = FactoryGirl.create :book, user: user
      sign_in user

      get :edit, { id: book.id }
      expect(response).to render_template(:edit)
    end

    it 'should redirect to sign_in when not logged in' do
      book = FactoryGirl.create :book

      get :edit, { id: book.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
