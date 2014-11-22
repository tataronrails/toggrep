require 'spec_helper'

describe TogglUser do

  subject {create(:user).toggl_user(true)}

  describe '#workspaces' do
    let(:user) {create(:user)}
    let(:workspaces) {TogglFactories.workspaces}

    it 'should return collection of workspaces which user have access' do
      allow(subject.toggl_client).to receive(:workspaces) {workspaces}
      expect(subject.workspaces.size).to eq(3)
    end
  end

end
