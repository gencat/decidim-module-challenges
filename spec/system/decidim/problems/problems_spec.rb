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

  describe("#index") do
    context "when list problems" do
      let(:other_component) { create(:problems_component) }
      let!(:older_problem) { create(:problem, component: component, created_at: 1.month.ago) }
      let!(:recent_problem) { create(:problem, component: component, created_at: Time.now.utc) }
      let!(:other_component_problem) { create(:problem, component: other_component, created_at: Time.now.utc) }
      let!(:problems) { create_list(:problem, 2, component: component) }

      before do
        visit_component
      end

      it "show only problems of current component" do
        expect(page).to have_selector(".card--problem", count: 4)
        expect(page).to have_content(translated(problems.first.title))
        expect(page).to have_content(translated(problems.last.title))
      end

      it "ordered randomly" do
        within ".order-by" do
          expect(page).to have_selector("ul[data-dropdown-menu$=dropdown-menu]", text: "Random")
        end

        expect(page).to have_selector(".card--problem", count: 4)
        expect(page).to have_content(translated(problems.first.title))
        expect(page).to have_content(translated(problems.last.title))
      end

      it "ordered by created at" do
        within ".order-by" do
          expect(page).to have_selector("ul[data-dropdown-menu$=dropdown-menu]", text: "Random")
          page.find("a", text: "Random").click
          click_link "Most recent"
        end

        expect(page).to have_selector("#problems .card-grid .column:first-child", text: recent_problem.title[:en])
        expect(page).to have_selector("#problems .card-grid .column:last-child", text: older_problem.title[:en])
      end
    end
  end
end
