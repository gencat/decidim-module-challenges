# frozen_string_literal: true

require "spec_helper"

describe "Problems", type: :system do
  include_context "with a component"
  let(:manifest_name) { "problems" }

  let(:solutions_component) { create(:solutions_component, participatory_space: problem.participatory_space) }

  describe "#show" do
    context "when a problem has contents" do
      let!(:problem) { create(:problem, component: component) }
      let!(:solution) { create(:solution, component: solutions_component, problem: problem) }

      before do
        visit_component
        click_link translated(problem.title)
      end

      it "does render the contents" do
        expect(page).to have_content("Keywords")
        expect(page).to have_content(translated(problem.tags))
        expect(page).to have_content("Proposed solutions")
        expect(page).to have_content(translated(solution.title))
      end
    end

    context "when a problem optional contents are empty" do
      let!(:problem) { create(:problem, component: component, tags: {}) }

      before do
        visit_component
        click_link translated(problem.title)
      end

      it "does not render titles for empty contents" do
        expect(page).not_to have_content("Keywords")
        expect(page).not_to have_content("Proposed solutions")
      end
    end
  end
end
