require 'rails_helper'

RSpec.describe API::V1::CortegeMembershipController, :type => :controller do

  describe 'GET #index' do
    before do
      login_with create( :admin )
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'responds with json' do
      expect { JSON.parse(response.body) }.not_to raise_exception
    end
  end
end