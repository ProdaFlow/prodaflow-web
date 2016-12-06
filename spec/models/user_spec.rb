require "rails_helper"

RSpec.describe User, :type => :model do
  it "should have a name field." do
    user = build(:user)
    expect(user).to respond_to(:name)
  end

  it "should have a user name field." do
    user = build(:user)
    expect(user).to respond_to(:email)
  end
end
