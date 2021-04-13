# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe Admin::UpdateSurveys do
    subject { described_class.new(form, challenge) }

    let(:challenge) { create(:challenge) }
    let(:invalid) { false }
    let(:survey_enabled) { true }

    let(:form) do
      double(
        invalid?: invalid,
        survey_enabled: survey_enabled,
      )
    end

    context "when the form is not valid" do
      let(:invalid) { true }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "updates the challenge" do
        subject.call
        expect(challenge.survey_enabled).to eq(survey_enabled)
      end
    end
  end
end
