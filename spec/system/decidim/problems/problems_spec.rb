# frozen_string_literal: true

require "spec_helper"

describe "Problems" do
  include_context "with a component"
  let(:manifest_name) { "problems" }

  let(:solutions_component) { create(:solutions_component, participatory_space: problem.participatory_space) }

  describe "#show" do
    context "when a problem has contents" do
      let!(:problem) { create(:problem, component:) }
      let!(:solution) { create(:solution, component: solutions_component, problem:) }

      before do
        visit_component
        click_on translated(problem.title)
      end

      it "does render the contents" do
        expect(page).to have_content("Keywords")
        expect(page).to have_content(translated(problem.tags))
        expect(page).to have_content("1 solution")
        expect(page).to have_content(translated(solution.title))
      end
    end

    context "when a problem optional contents are empty" do
      let!(:problem) { create(:problem, component:, tags: {}) }

      before do
        visit_component
        click_on translated(problem.title)
      end

      it "does not render titles for empty contents" do
        expect(page).to have_no_content("Keywords")
        expect(page).to have_no_content("solutions")
      end
    end
  end

  describe("#index") do
    context "when list problems" do
      let(:other_component) { create(:problems_component) }
      let!(:older_problem) { create(:problem, component:, created_at: 1.month.ago) }
      let!(:recent_problem) { create(:problem, component:, created_at: Time.now.utc) }
      let!(:other_component_problem) { create(:problem, component: other_component, created_at: Time.now.utc) }
      let!(:problems) { create_list(:problem, 2, component:) }

      before do
        visit_component
      end

      it "show only problems of current component" do
        expect(page).to have_css(".card__list", count: 4)
        expect(page).to have_content(translated(problems.first.title))
        expect(page).to have_content(translated(problems.last.title))
      end

      it "ordered randomly" do
        within ".order-by" do
          page.find("a", text: "Random").click
        end

        expect(page).to have_css(".card__list", count: 4)
        expect(page).to have_content(translated(problems.first.title))
        expect(page).to have_content(translated(problems.last.title))
      end

      it "ordered by created at" do
        within ".order-by" do
          page.find("a", text: "Most recent").click
        end

        expect(page).to have_css(".order-by .button:first-child", text: recent_problem.title[:en])
        expect(page).to have_css(".order-by .button:last-child", text: older_problem.title[:en])
      end
    end
  end
end
