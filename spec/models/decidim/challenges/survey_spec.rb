# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe Survey do
    subject { survey }

    let(:challenge) { create(:challenge) }
    let(:author) { create(:user, organization: challenge.organization) }
    let(:survey) { build(:survey, challenge:, author:) }

    it { is_expected.to be_valid }

    context "when a survey already exists for the same user and challenge" do
      before do
        create(:survey, challenge:, author:)
      end

      it { is_expected.not_to be_valid }
    end
  end
end
