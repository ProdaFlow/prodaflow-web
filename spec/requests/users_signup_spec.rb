require 'rails_helper'

RSpec.describe 'UsersSignup', type: :request do
  it 'valid signup information' do
    get signup_path
    expect {
      post users_path, params: { user: { name: 'Bob Barker',
                                         email: 'bob@barker.com',
                                         password: 'Password1',
                                         password_confirmation: 'Password1' } }
    }.to change{User.count}.by(1)

    follow_redirect!

    expect(response).to render_template('users/show')
    expect(!session[:user_id].nil?).to be true
  end

  it 'sign up fails on database save' do
    allow_any_instance_of(User).to receive(:save).and_return(false)

    post users_path, params: { user: { name: 'Bob Barker',
                               email: 'bob2@barker.com',
                               password: 'Password1',
                               password_confirmation: 'Password1' } }
    expect(response).to render_template('users/new')
  end
end
