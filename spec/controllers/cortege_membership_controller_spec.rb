require 'rails_helper'

RSpec.describe API::V1::CortegeMembershipController, :type => :controller do

  describe "GET #index" do
    before do
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "response with json containing all cortege_memberships" do
      expect { JSON.parse(response.body).with_indifferent_access }.not_to raise_exception

    end
  end
end