require "rails_helper"

RSpec.describe User, :type => :model do
  it "should have a name field." do
    user = build(:user)
    expect(user).to respond_to(:name)
  end

  it "should have an email field." do
    user = build(:user)
    expect(user).to respond_to(:email)
  end

  it "should verify name is provided." do
    should validate_presence_of(:name)
  end

  it "should verify email is provided." do
    should validate_presence_of(:email)
  end

  it "should pass validation when given valid parameters." do
    user = build(:user)
    expect(user.valid?).to be true
  end

  it "should fail validation when nil or empty parameters." do
    user = build(:empty_user)
    expect(user.valid?).to be false
  end

  it "should raise error if email length is greater than 150 characters." do
    should validate_length_of(:email).is_at_most(150)
  end

  it "should raise error if name length is greater than 150 characters." do
    should validate_length_of(:name).is_at_most(150)
  end
end
