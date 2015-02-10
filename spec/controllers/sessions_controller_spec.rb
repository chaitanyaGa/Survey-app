require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe 'GET #new' do
    subject {get :new}

    it 'renders new template' do
      expect(subject).to render_template(:new)
      expect(subject).to render_template('new')
      expect(response).to render_template('sessions/new')
    end

    it 'returns 200 status code' do
      expect(subject).to have_http_status(200)
    end

  end

  describe 'sessions#create'do
    before(:all)do
      #create_user()
    end
    it 'accepts the post request' do
      post :new, 'user' => {'username' => 'Name','password' => '21'}
      expect(response).to have_http_status(200)
      # build attributes for user!!!
    end

    it 'renders the new template for wrong password'do
      post :new, 'user' => {'username' => 'name', 'password' => '21'}
      expect(response).to render_template(:new)
    end

    it 'renders the new template for wrong user name'do
      post :new, 'user' =>{'username'=> '',password: '12' }
    end

    it 'renders the survey#index for right user name and password'do
    end
  end

end
