require 'spec_helper'

describe TogglProject do

  describe '.project_users' do
    let(:user) {build(:user)}
    let(:toggl_client) { double('toggl_client') }
    let(:workspace) { double('workspace') }
    let(:toggl_project_users) do
      arr = []
      4.times do |i|
        obj = Object.new
        allow(obj).to receive(:uid) {"2905#{i}"}
        arr << obj
      end
      arr
    end
    let(:toggl_workspace) do
      arr = []
      4.times do |i|
        obj = Object.new
        allow(obj).to receive(:uid) {"2905#{i}"}
        allow(obj).to receive(:inactive) {i < 2 ? true : false}
        arr << obj
      end
      arr
    end

    it 'should return list of active users of project' do
      allow(user).to receive(:id) {1}
      Toggl::Base.stub(:new).with(user.toggl_api_key, 1) {toggl_client}
      allow(toggl_client).to receive(:project_users).with(1) {toggl_project_users}
      allow(toggl_client).to receive(:project).with(1) {workspace}
      allow(workspace).to receive(:wid) {1}
      allow(toggl_client).to receive(:get_relations_of_workspace_and_user).with(1) {toggl_workspace}
      expect(TogglProject.project_users(user, 1).size).to eq(2)
    end

    it 'should return list of project users' do
      allow(user).to receive(:id) {1}
      Toggl::Base.stub(:new).with(user.toggl_api_key, 1) {toggl_client}
      allow(toggl_client).to receive(:project_users).with(1) {toggl_project_users}
      expect(TogglProject.project_users(user, 1, false).size).to eq(4)
    end
  end

end
