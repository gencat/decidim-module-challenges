# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe ChallengeCell, type: :cell do
    controller Decidim::Challenges::ChallengesController

    let!(:challenge) { create(:challenge) }

    context "when rendering" do
      it "renders the card" do
        html = cell("decidim/challenges/challenge", challenge).call
        expect(html).to have_css(".card--challenge")
      end
    end
  end
end
