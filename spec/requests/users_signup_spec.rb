require 'rails_helper'
require 'login_helper'

RSpec.describe 'UsersSignup', type: :request do
  include_context 'Login Helpers'

  before { ActionMailer::Base.deliveries.clear }

  it 'valid signup information' do
    get signup_path
    expect {
      post users_path, params: { user: { name: 'Bob Barker',
                                         email: 'bob@barker.com',
                                         password: 'Password1',
                                         password_confirmation: 'Password1' } }
    }.to change{User.count}.by(1)

    follow_redirect!

    #expect(response).to render_template('users/show')
    #expect(!session[:user_id].nil?).to be true
  end

  it 'sign up fails on database save' do
    allow_any_instance_of(User).to receive(:save).and_return(false)

    post users_path, params: { user: { name: 'Bob Barker',
                               email: 'bob2@barker.com',
                               password: 'Password1',
                               password_confirmation: 'Password1' } }
    expect(response).to render_template('users/new')
  end

  it 'valid signup information with activation' do
    get signup_path

    expect {
      post users_path, params: { user: { name: 'Bob Barker',
                                         email: 'bob2@barker.com',
                                         password: 'Password1',
                                         password_confirmation: 'Password1' } }
    }.to change{User.count}.by(1)

    expect(ActionMailer::Base.deliveries.size).to eq(1)
    user = assigns(:user)
    expect(user.activated?).to be false
    # Try to log in before activation.
    log_in_as(user)
    expect(is_logged_in?).to be false
    # Try invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    expect(is_logged_in?).to be false
    # Try valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    expect(is_logged_in?).to be false
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    expect(user.reload.activated?).to be true
    follow_redirect!
    assert_template 'users/show'
    expect(is_logged_in?).to be true
  end
end
