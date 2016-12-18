require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  before do
    @user = FactoryGirl.create(:user)
    remember(@user)
  end

  context 'when session is nil' do
    it 'current_user returns right user' do
      expect(@user).to eq(current_user)
      expect(logged_in?).to be true
    end
  end

  context 'when remember digest is wrong' do
    it 'current_user returns nil' do
      @user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end
