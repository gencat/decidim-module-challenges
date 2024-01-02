# frozen_string_literal: true

require "spec_helper"

describe "Challenges", type: :system do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let(:solutions_component) { create(:solutions_component, participatory_space: challenge.participatory_space) }

  describe "#show" do
    context "when a challenge has contents" do
      let!(:challenge) { create(:challenge, component: component) }
      let(:problems_component) { create(:problems_component, participatory_space: challenge.participatory_space) }
      let(:problem) { create :problem, component: problems_component, challenge: challenge }
      let!(:solution) { create(:solution, component: solutions_component, problem: problem) }

      before do
        visit_component
        click_link translated(challenge.title)
      end

      it "does render the contents" do
        expect(page).to have_content("Keywords")
        expect(page).to have_content(translated(challenge.tags))
        expect(page).to have_content("Associated problems")
        expect(page).to have_content(translated(problem.title))
        expect(page).to have_content("Proposed solutions")
        expect(page).to have_content(translated(solution.title))
      end
    end

    context "when a challenge optional contents are empty" do
      let!(:challenge) { create(:challenge, component: component, tags: {}) }

      before do
        visit_component
        click_link translated(challenge.title)
      end

      it "does not render titles for empty contents" do
        expect(page).not_to have_content("Keywords")
        expect(page).not_to have_content("Associated problems")
        expect(page).not_to have_content("Proposed solutions")
      end
    end
  end

  describe("#index") do
    context "when list challenges" do
      let(:other_component) { create(:challenges_component, :with_card_image_allowed) }
      let!(:older_challenge) { create(:challenge, component: component, created_at: 1.month.ago) }
      let!(:recent_challenge) { create(:challenge, component: component, created_at: Time.now.utc) }
      let!(:other_component_challenge) { create(:challenge, component: other_component, created_at: Time.now.utc) }
      let!(:challenges) { create_list(:challenge, 2, component: component) }

      before do
        visit_component
      end

      it "show only challenges of current component" do
        expect(page).to have_selector(".card--challenge", count: 4)
        expect(page).to have_content(translated(challenges.first.title))
        expect(page).to have_content(translated(challenges.last.title))
      end

      it "ordered randomly" do
        within ".order-by" do
          expect(page).to have_selector("ul[data-dropdown-menu$=dropdown-menu]", text: "Random")
        end

        expect(page).to have_selector(".card--challenge", count: 4)
        expect(page).to have_content(translated(challenges.first.title))
        expect(page).to have_content(translated(challenges.last.title))
      end

      it "ordered by created at" do
        within ".order-by" do
          expect(page).to have_selector("ul[data-dropdown-menu$=dropdown-menu]", text: "Random")
          page.find("a", text: "Random").click
          click_link "Most recent"
        end

        expect(page).to have_selector("#challenges .card-grid .column:first-child", text: recent_challenge.title[:en])
        expect(page).to have_selector("#challenges .card-grid .column:last-child", text: older_challenge.title[:en])
      end
    end

    context "when card images are allow" do
      let!(:challenge_with_card_image) { create(:challenge, :with_card_image, component: component) }
      let!(:challenge) { create(:challenge, component: component) }

      context "when list all challenges" do
        before do
          component.update(settings: { allow_card_image: true })
          visit_component
        end

        it "show cards with images" do
          expect(page).to have_selector(".card--challenge", count: 2)
          expect(page).to have_selector(".card__image", count: 1)

          expect(page).to have_content(translated(challenge_with_card_image.title))
          expect(page).to have_content(translated(challenge.title))
        end
      end
    end
  end
end
