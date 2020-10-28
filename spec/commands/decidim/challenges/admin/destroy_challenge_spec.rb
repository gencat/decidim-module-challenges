# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Challenges
    module Admin
      describe DestroyChallenge do
        subject { described_class.new(challenge, current_user) }

        let(:my_process) { create :participatory_process }
        let!(:current_user) { create :user, email: 'some_email@example.org', organization: my_process.organization }
        let!(:user) { create :user, :confirmed, organization: my_process.organization }
        let(:challenge) { create :challenge }

        context 'when everything is ok' do
          it 'deletes the challenge' do
            subject.call
            expect { challenge.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it 'traces the action', versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with('delete', challenge, current_user)
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
            expect(action_log.version.event).to eq 'destroy'
          end
        end
      end
    end
  end
end
