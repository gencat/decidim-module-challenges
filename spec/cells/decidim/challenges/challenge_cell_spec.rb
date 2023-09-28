# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe ChallengeCell, type: :cell do
    controller Decidim::Challenges::ChallengesController

    let(:description) do
      Decidim::Faker::Localized.sentence
    end

    let!(:challenge) { create :challenge, global_description: description }
    let!(:challenge_title) { translated(challenge.title) }
    let(:html) { cell("decidim/challenges/challenge", challenge, context: { show_space: show_space }).call }
    let!(:challenge_description) { translated(challenge.global_description) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(html).to have_css(".card--challenge")
      end

      it "renders the challenge description" do
        expect(html).to have_content(challenge_description)
      end

      it "renders the challenge title" do
        expect(html).to have_content(challenge_title)
      end
    end
  end
end
