require 'rails_helper'
require 'login_helper'

RSpec.describe 'UsersLogins', type: :request do
  include_context 'Login Helpers'

  let(:created_user) { FactoryGirl.create :user }
  let(:unactivated) { FactoryGirl.create :unactivated_user }

  describe 'User attempts to' do
    it 'login with invalid credentials' do
      get login_path
      expect(response).to render_template('sessions/new')

      post login_path, params: { session: { email: '', password: '' } }
      expect(response).to render_template('sessions/new')
      expect(flash.empty?).to be false

      get root_path
      expect(flash.empty?).to be true
    end

    it 'login to unactivated account' do
      post login_path, params: { session: { email: unactivated.email,
                                            password: 'MyPassword1' } }
      expect(is_logged_in?).to be false
      expect(response).to redirect_to(root_path)
    end

    it 'login with valid credentials' do
      get login_path

      post login_path, params: { session: { email: created_user.email,
                                            password: 'MyPassword1' } }
      expect(response).to redirect_to(created_user)

      follow_redirect!

      expect(response).to render_template('users/show')
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
    end

    it 'logout after login' do
      get login_path
      post login_path, params: { session: { email: created_user.email,
                                            password: 'MyPassword1' } }
      expect(is_logged_in?).to be true
      expect(response).to redirect_to created_user
      follow_redirect!

      expect(response).to render_template 'users/show'
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path

      delete logout_path
      expect(is_logged_in?).to be false
      expect(response).to redirect_to root_url
    end

    it 'login with remembering' do
      log_in_as(created_user, remember_me: '1')
      expect(cookies['remember_token']).to_not be_nil
    end

    it 'login without remembering' do
      log_in_as(created_user, remember_me: '1')
      log_in_as(created_user, remember_me: '0')
      expect(cookies['remember_token']).to eql('')
    end

    it 'login using remember me token' do
      log_in_as(created_user, remember_me: '1')
      # Simulate closing of browser
      session.delete(:user_id)

      get login_path
      expect(response).to  redirect_to(created_user)
    end
  end
end
