require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it 'returns base description with no title' do
    expect(helper.full_title('')).to eq('Prodaflow')
  end

  it 'returns full description with title' do
    expect(helper.full_title('Sign Up')).to eq('Prodaflow | Sign Up')
  end
end
