require 'spec_helper'

describe TogglWorkspace do

  let(:user) {create(:user)}
  subject {TogglFactories.workspaces(user)[0]}

  describe '#users' do
    let(:workspace_users) {TogglFactories.workspace_users(1)}
    let(:toggl_client) {double 'toggl_client'}
    let(:workspace_projects) {TogglFactories.workspace_projects(1)}
    let(:workspace_project1) {TogglFactories.workspace1_project_users(1)}
    let(:workspace_project2) {TogglFactories.workspace1_project_users(2)}
    let(:workspace_project3) {TogglFactories.workspace1_project_users(3)}

    it 'should return user collection of workspace' do
      allow(Toggl::Base).to receive(:new).with(user.toggl_api_key, user.id) {toggl_client}
      allow(toggl_client).to receive(:get_relations_of_workspace_and_user).with(1) {workspace_users}
      allow(toggl_client).to receive(:get_workspace_projects).with(1) {workspace_projects}
      allow(toggl_client).to receive(:project_users).with(1) {workspace_project1}
      allow(toggl_client).to receive(:project_users).with(2) {workspace_project2}
      allow(toggl_client).to receive(:project_users).with(3) {workspace_project3}
      users = subject.get_users_with_projects
      expect(users.size).to eq(3)
      expect(users[0].projects.size).to eq(3)
      expect(users[1].projects.size).to eq(2)
    end
  end

end
