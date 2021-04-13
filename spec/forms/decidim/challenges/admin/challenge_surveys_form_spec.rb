# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe Admin::ChallengeSurveysForm do
    subject { described_class.from_params(attributes).with_context(context) }

    let(:challenge) { create(:challenge) }
    let(:attributes) do
      {
        survey_enabled: survey_enabled,
      }
    end
    let(:survey_enabled) { true }
    let(:context) { { current_organization: challenge.organization, challenge: challenge } }

    context "when surveys are enabled" do
      it { is_expected.to be_valid }
    end
  end
end
