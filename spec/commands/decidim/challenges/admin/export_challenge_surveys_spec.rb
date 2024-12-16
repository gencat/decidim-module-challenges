# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe Admin::ExportChallengeSurveys do
    subject { described_class.new(challenge, format, user) }

    let(:challenge) { create(:challenge) }
    let(:format) { "CSV" }
    let(:user) { create(:user, :admin) }

    context "when everything is ok" do
      it "exports the challenge survey" do
        exporter_double = double(export: true)
        class_double = double(new: exporter_double)
        allow(Decidim::Exporters)
          .to receive(:find_exporter)
          .with(format)
          .and_return(class_double)

        subject.call
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with(:export_surveys, challenge, user)
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
