# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe ChallengeCell, type: :cell do
    controller Decidim::Challenges::ChallengesController

    let(:description) do
      Decidim::Faker::Localized.sentence
    end

    let(:component) { create(:challenges_component, :with_card_image_allowed) }
    let!(:challenge) { create :challenge, :with_card_image, global_description: description, component: component }
    let(:model) { challenge }
    let(:cell_html) { cell("decidim/challenges/challenge_m", challenge, context: { show_space: show_space }).call }
    let!(:challenge_description) { translated(challenge.global_description) }
    let!(:challenge_title) { translated(challenge.title) }

    context "when rendering" do
      let(:show_space) { false }
      let!(:card_image) { create(:attachment, :with_image, attached_to: challenge) }

      it "renders the card" do
        expect(cell_html).to have_css(".card--challenge")
      end

      it "renders the challenge description" do
        expect(cell_html).to have_content(challenge_description)
      end

      it "renders the challenge title" do
        expect(cell_html).to have_content(challenge_title)
      end

      it "renders the challenge image card" do
        expect(cell_html).to have_css(".card__image")
      end
    end
  end
end
