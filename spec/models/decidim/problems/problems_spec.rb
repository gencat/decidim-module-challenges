# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Problems
    describe Problem do
      subject { problem }

      let(:problem) { build(:problem) }

      it { is_expected.to be_valid }
      it { is_expected.to be_versioned }

      include_examples "has component"
      # include_examples "has scope"
      include_examples "publicable"
      include_examples "resourceable"
    end
  end
end
