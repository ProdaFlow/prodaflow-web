require 'rails_helper'

RSpec.describe 'UsersLogins', type: :request do
  describe 'User attempts to' do
    it 'login with invalid information' do
      get login_path
      expect(response).to render_template('sessions/new')

      post login_path, params: { session: { email: "", password: "" } }
      expect(response).to render_template('sessions/new')
      expect(flash.empty?).to be false

      get root_path
      expect(flash.empty?).to be true
    end
  end
end
