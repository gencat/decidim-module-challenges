# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Problems
    module Admin
      describe DestroyProblem do
        subject { described_class.new(problem, current_user) }

        let(:my_process) { create(:participatory_process) }
        let!(:current_user) { create(:user, email: "some_email@example.org", organization: my_process.organization) }
        let!(:user) { create(:user, :confirmed, organization: my_process.organization) }
        let(:problem) { create(:problem) }

        context "when everything is ok" do
          it "deletes the problem" do
            subject.call
            expect { problem.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it "traces the action", versioning: true do
            expect(Decidim.traceability)
              .to receive(:perform_action!)
              .with("delete", problem, current_user)
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)
            action_log = Decidim::ActionLog.last
            expect(action_log.version).to be_present
            expect(action_log.version.event).to eq "destroy"
          end
        end

        context "when has dependent solutions" do
          let(:solution) { create(:solution, problem:) }

          it "not deletes the problem" do
            expect { subject.call }.not_to change(Decidim::Problems::Problem, :count)
          end
        end
      end
    end
  end
end
