require 'spec_helper'

describe Agreement do

  subject { create(:agreement) }

  describe 'constants' do
    it { expect(Agreement::STATES).to eql(%w(proposed changed_by_worker changed_by_manager rejected accepted canceled)) }
  end

  describe 'associations' do
    it { expect(subject).to belong_to(:manager).class_name('User') }
    it { expect(subject).to belong_to(:worker).class_name('User') }
  end

  describe 'states' do
    it { expect(subject).to be_proposed }
    specify { subject.accept; expect(subject).to be_accepted }
    specify { subject.reject; expect(subject).to be_rejected }
    specify { subject.cancel; expect(subject).to be_canceled }
    specify {
      subject.change_by_worker
      expect(subject).to be_changed_by_worker
    }
    specify {
      subject.state = 'changed_by_worker'
      subject.change_by_manager
      expect(subject).to be_changed_by_manager
    }
  end

end
