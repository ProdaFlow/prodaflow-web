require 'rails_helper'
require 'login_helper'

RSpec.describe "PasswordResets", type: :request do
  include_context 'Login Helpers'

  before { ActionMailer::Base.deliveries.clear }
  let(:created_user) { FactoryGirl.create :user }

  describe 'User attempts to' do
    it 'password resets' do
      get new_password_reset_path
      expect(response).to render_template('password_resets/new')
      # Invalid email
      post password_resets_path, params: { password_reset: { email: '' } }
      expect(flash.empty?).to be false
      expect(response).to render_template('password_resets/new')
      # Valid email
      post password_resets_path,
           params: { password_reset: { email: created_user.email } }
      expect(created_user.reset_digest).to_not eq(created_user.reload.reset_digest)
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(flash.empty?).to be false
      expect(response).to redirect_to(root_url)
      # Password reset form
      user = assigns(:user)
      # Wrong email
      get edit_password_reset_path(user.reset_token, email: '')
      expect(response).to redirect_to(root_url)
      # Inactive user
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to redirect_to(root_url)
      user.toggle!(:activated)
      # Right email, wrong token
      get edit_password_reset_path('wrong token', email: user.email)
      expect(response).to redirect_to(root_url)
      # Right email, right token
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to render_template('password_resets/edit')
      assert_select 'input[name=email][type=hidden][value=?]', user.email
      # Invalid password & confirmation
      patch password_reset_path(user.reset_token),
            params: { email: user.email,
                      user: { password:              'foobaz',
                              password_confirmation: 'barquux'} }
      assert_select 'div#error_explanation'
      # Empty password
      patch password_reset_path(user.reset_token),
            params: { email: user.email,
                      user: { password:              '',
                              password_confirmation: ''} }
      assert_select 'div#error_explanation'
      # Valid password & confirmation
      patch password_reset_path(user.reset_token),
            params: { email: user.email,
                      user: { password:              'MyPassword1234',
                              password_confirmation: 'MyPassword1234' } }
      expect(is_logged_in?).to be true
      expect(flash.empty?).to be false
      expect(response).to redirect_to(user)
    end

    it 'expired token' do
      get new_password_reset_path
      post password_resets_path,
           params: { password_reset: { email: created_user.email } }

      created_user = assigns(:user)
      created_user.update_attribute(:reset_sent_at, 3.hours.ago)
      patch password_reset_path(created_user.reset_token),
            params: { email: created_user.email,
                      user: { password:              'MyPassword1234',
                              password_confirmation: 'MyPassword1234' } }
      assert_response :redirect
    end
  end
end
