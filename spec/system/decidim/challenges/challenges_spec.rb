# frozen_string_literal: true

require "spec_helper"

describe "Challenges", :slow do
  include ActionView::Helpers::SanitizeHelper

  include_context "with a component"
  let(:manifest_name) { "challenges" }

  describe "#show" do
    context "when a challenge has contents" do
      let!(:challenge) { create(:challenge, component:) }
      let(:problems_component) { create(:problems_component, participatory_space: challenge.participatory_space) }
      let!(:problem) { create(:problem, component: problems_component, challenge:) }
      let(:solutions_component) { create(:solutions_component, participatory_space: challenge.participatory_space) }
      let!(:solution) { create(:solution, component: solutions_component, problem:) }

      before do
        visit_component
        click_on translated(challenge.title)
      end

      it "does render the contents" do
        expect(page).to have_content("Keywords")
        expect(page).to have_content(translated(challenge.tags))
        expect(page).to have_content("1 problem")
        expect(page).to have_content(translated(problem.title))
        expect(page).to have_content("1 solution")
        expect(page).to have_content(translated(solution.title))
      end
    end

    context "when a challenge optional contents are empty" do
      let!(:challenge) { create(:challenge, component:, tags: {}) }

      before do
        visit_component
        click_link_or_button translated(challenge.title)
      end

      it "does not render titles for empty contents" do
        expect(page).to have_no_content("Keywords")
        expect(page).to have_no_content("1 problem")
        expect(page).to have_no_content("1 solution")
      end
    end
  end

  describe("#index") do
    context "when list challenges" do
      let(:other_component) { create(:challenges_component, :with_card_image_allowed) }
      let!(:older_challenge) { create(:challenge, component:, created_at: 1.month.ago) }
      let!(:recent_challenge) { create(:challenge, component:, created_at: Time.now.utc) }
      let!(:other_component_challenge) { create(:challenge, component: other_component, created_at: Time.now.utc) }
      let!(:challenges) { create_list(:challenge, 2, component:) }

      before do
        visit_component
      end

      it "show only challenges of current component" do
        expect(page).to have_css(".card__list", count: 4)
        expect(page).to have_content(translated(challenges.first.title))
        expect(page).to have_content(translated(challenges.last.title))
      end

      it "ordered randomly" do
        within ".order-by" do
          page.find("a", text: "Random").click
        end

        expect(page).to have_css(".card__list", count: 4)
        expect(page).to have_content(translated(challenges.first.title))
        expect(page).to have_content(translated(challenges.last.title))
      end

      it "ordered by created at" do
        within ".order-by" do
          page.find("a", text: "Random").click_on
          click_on "Most recent"
        end

        expect(page).to have_css(".order-by .button:first-child", text: recent_challenge.title[:en])
        expect(page).to have_css(".order-by .button:last-child", text: older_challenge.title[:en])
      end
    end

    context "when card images are allow" do
      let!(:challenge_with_card_image) { create(:challenge, :with_card_image, component:) }
      let!(:challenge) { create(:challenge, component:) }

      context "when list all challenges" do
        before do
          component.update(settings: { allow_card_image: true })
          visit_component
        end

        it "show cards with images" do
          expect(page).to have_css(".card__list", count: 2)
          expect(page).to have_css(".card__list-image", count: 2)

          expect(page).to have_content(translated(challenge_with_card_image.title))
          expect(page).to have_content(translated(challenge.title))
        end
      end
    end
  end
end
