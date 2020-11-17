# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe ChallengeListItemCell, type: :cell do
    let!(:challenge) { create(:challenge) }

    let(:organization) { create(:organization, available_locales: [:en]) }
    let(:context) do
      {
        current_organization: organization,
        current_component: current_component,
        current_participatory_space: participatory_process
      }
    end
    context "when rendering" do
      it "renders the card" do
        html = cell("decidim/challenges/challenge_list_item", challenge).call
        expect(html).to have_css(".card__content")
      end
    end
  end
end
