require 'rails_helper'

RSpec.describe API::V1::CortegeMembershipController, :type => :controller do

  describe 'GET :index' do
    before do
      login_with create( :user, :admin )
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'responds with json' do
      expect { JSON.parse(response.body) }.not_to raise_exception
    end
  end

  describe 'POST :create' do
    before do
      @logged_in_user = create ( :user_with_cortege )
      login_with @logged_in_user

      @user_to_add = create ( :user )
      @another_user_with_cortege = create ( :user_with_cortege )
    end

    let(:valid_params) {{
        :cortege_membership => {
            :cortege_id => @logged_in_user.cortege.id
        },
        :user => {
            :email => @user_to_add.email
        }
    }}


    context 'with valid params' do
      let(:create_membership) {
        post :create, params: valid_params
      }

      it 'assigns a cortege membership to user' do
        expect {create_membership}.to change(CortegeMembership, :count).by 1
      end

      it 'returns http success' do
        expect(create_membership).to have_http_status :success
      end
    end

    let(:invalid_params_add_self) {{
        :cortege_membership => {
            :cortege_id => @logged_in_user.cortege.id
        },
        :user => {
            :email => @logged_in_user.email
        }
    }}

    let(:invalid_params_non_existent_user) {{
        :cortege_membership => {
            :cortege_id => @logged_in_user.cortege.id
        },
        :user => {
            :email => 'nouser@sof17.se'
        }
    }}

    let(:invalid_params_others_cortege) {{
        :cortege_membership => {
            :cortege_id => @another_user_with_cortege.cortege.id,
        },
        :user => {
            :email => @user_to_add.email
        }
    }}

    context 'with invalid params' do
      let(:create_membership_for_self) {
        post :create, params: invalid_params_add_self
      }

      it 'cannot create cortege membership for self' do
        expect {create_membership_for_self}.to change(CortegeMembership, :count).by 0
      end

      let(:create_membership_for_non_existent_user) {
        post :create, params: invalid_params_non_existent_user
      }

      it 'cannot create cortege membership for non existent user' do
        expect {create_membership_for_non_existent_user}.to change(CortegeMembership, :count).by 0
      end

      let(:create_membership_for_other_cortege) {
        post :create, params: invalid_params_others_cortege
      }

      it 'cannot create cortege membership for someone elses cortege' do
        expect {create_membership_for_other_cortege}.to change(CortegeMembership, :count).by 0
      end

      it 'returns http failure' do
        expect(create_membership_for_self).to have_http_status 400
        expect(create_membership_for_non_existent_user).to have_http_status 400
        expect(create_membership_for_other_cortege).to have_http_status 403
      end
    end
  end

  describe 'DELETE :destroy' do
    before do
      @logged_in_user = create ( :user_with_cortege )
      login_with  @logged_in_user

      @cortege = create ( :cortege_with_members )
    end
  end
end