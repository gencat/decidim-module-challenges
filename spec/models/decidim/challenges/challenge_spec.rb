# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Challenges
    describe Challenge do
      subject { challenge }

      let(:challenge) { build(:challenge) }

      it { is_expected.to be_valid }
      it { is_expected.to be_versioned }

      include_examples "has component"
      include_examples "publicable"
      include_examples "resourceable"

      it "has an association with one questionnaire" do
        subject.questionnaire = build_stubbed(:questionnaire)
        expect(subject.questionnaire).to be_present
      end
    end
  end
end
