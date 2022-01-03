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
end
