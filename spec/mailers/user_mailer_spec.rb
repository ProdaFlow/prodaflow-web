require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:created_user) { FactoryGirl.create(:user) }

    it 'account_activation' do
      created_user.activation_token = User.new_token
      mail = UserMailer.account_activation(created_user)

      expect(mail.subject).to eq('Account activation')
      expect(mail.to).to eq([created_user.email])
      expect(mail.from).to eq(['noreply@prodaflow.io'])
      expect(mail.body.encoded).to include(created_user.name)
      expect(mail.body.encoded).to include(created_user.activation_token)
      expect(mail.body.encoded).to include(CGI.escape(created_user.email))
    end
  end
end
