require 'spec_helper'

describe User do

  subject { create(:user) }

  describe 'associations' do
    it { expect(subject).to have_one(:toggl_user).dependent(:destroy) }
  end

  describe 'validations' do
    it { expect(subject).to validate_presence_of(:email) }
    it { expect(subject).to validate_presence_of(:password) }
    it { expect(subject).to validate_presence_of(:toggl_api_key) }
    it { expect(subject).to ensure_length_of(:toggl_api_key).is_equal_to(32) }
  end

  describe '#to_s' do
    it { expect(subject.to_s).to equal(subject.toggl_user.to_s) }
  end

end
