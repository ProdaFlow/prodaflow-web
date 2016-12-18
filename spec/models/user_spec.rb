require "rails_helper"

RSpec.describe User, :type => :model do
  it "has a name field." do
    user = build(:user)
    expect(user).to respond_to(:name)
  end

  it "has an email field." do
    user = build(:user)
    expect(user).to respond_to(:email)
  end

  it "verifies that name is provided." do
    should validate_presence_of(:name)
  end

  it "verifies that email is provided." do
    should validate_presence_of(:email)
  end

  it "fails validation if email length is greater than 150 characters." do
    should validate_length_of(:email).is_at_most(150)
  end

  it "fails validation if name length is greater than 150 characters." do
    should validate_length_of(:name).is_at_most(150)
  end

  it "passses validation if user has valid email address." do
    user = build(:user)
    expect(user.valid?).to eq(true)
  end

  it "has no '@' in email address." do
    user = build(:user)
    user.email = "hi.com"
    expect(user.valid?).to eq(false)
  end

  it "has two '..' in email address." do
    user = build(:user)
    user.email = "hello@hi..com"
    expect(user.valid?).to eq(false)
  end

  it "must have unique email address." do
    user = build(:user)
    dup = user.dup
    user.save
    expect(dup.valid?).to eq(false)
  end

  it "downcases email address on save." do
    user = build(:user)
    user.email = "myEmail@Gmail.com"
    user.save
    user.reload
    expect(user.email).to eq("myemail@gmail.com")
  end

  it "must meet password complexity requirements." do
    user = build(:user, email: 'hi@email.com',
                        password: 'ComplexPassword1',
                        password_confirmation: 'ComplexPassword1')
    expect(user.valid?).to eq(true)
  end

  context 'when user has nil digest' do
    it 'authenticated? should return false' do
      user = build(:user, email: 'james.bond@mia.gov.uk')
      expect(user.authenticated?(:remember, '')).to be false
    end
  end
end
