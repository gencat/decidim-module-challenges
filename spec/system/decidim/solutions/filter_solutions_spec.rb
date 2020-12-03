# frozen_string_literal: true

require "spec_helper"

describe "Filter Solutions", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "solutions" }

  let!(:category) { create :category, participatory_space: participatory_process }
  let!(:scope) { create :scope, organization: organization }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization: organization, scope: scope) }

  describe "when filtering solutions by SDG" do
    context "when the participatory_space does NOT contain an SDGs component" do
      before do
        visit_component
      end

      it "the filter is not rendered" do
        expect(page).not_to have_css(".filters__section.sdgs-filter")
      end
    end

    context "when the participatory_space DOES contain an SDGs component" do
      let!(:sdgs_component) { create(:sdgs_component, participatory_space: participatory_process) }
      let!(:challenges_component) { create(:challenges_component, participatory_space: participatory_process) }
      let!(:problems_component) { create(:problems_component, participatory_space: participatory_process) }

      before do
        challenge = create(:challenge, component: challenges_component, sdg_code: :no_poverty)
        problem = create(:problem, component: problems_component, challenge: challenge)
        create_list(:solution, 2, component: component, problem: problem)
        challenge = create(:challenge, component: challenges_component, sdg_code: :zero_hunger)
        problem = create(:problem, component: problems_component, challenge: challenge)
        create(:solution, component: component, problem: problem)
        challenge = create(:challenge, component: challenges_component, sdg_code: :good_health)
        problem = create(:problem, component: problems_component, challenge: challenge)
        create(:solution, component: component, problem: problem)
        challenge = create(:challenge, component: challenges_component)
        problem = create(:problem, component: problems_component, challenge: challenge)
        create(:solution, component: component, problem: problem)
        visit_component
      end

      it "the filter is rendered" do
        expect(page).to have_css(".filters__section.sdgs-filter")
      end

      context "when NOT selecting any SDG" do
        it "lists all the solutions" do
          expect(page).to have_css(".card--solution", count: 5)
          expect(page).to have_content("5 SOLUTIONS")
        end
      end

      context "when selecting some SDGs" do
        before do
          find(".filters__section.sdgs-filter button").click
          expect(page).to have_css("#sdgs-modal")
          find('#sdgs-modal .sdg-cell[data-value="no_poverty"]').click
          find('#sdgs-modal .sdg-cell[data-value="good_health"]').click
          find("#sdgs-modal .reveal__footer a.button").click
        end

        it "lists the solutions with the selected SDGs" do
          expect(page).to have_css(".card--solution", count: 3)
          expect(page).to have_content("3 SOLUTIONS")
        end
      end
    end
  end

  # context "when filtering solutions by CATEGORY", :slow do
  #   context "when the user is logged in" do
  #     let!(:category2) { create :category, participatory_space: participatory_process }
  #     let!(:category3) { create :category, participatory_space: participatory_process }
  #     let!(:solution1) { create(:solution, component: component, category: category) }
  #     let!(:solution2) { create(:solution, component: component, category: category2) }
  #     let!(:solution3) { create(:solution, component: component, category: category3) }

  #     before do
  #       login_as user, scope: :user
  #     end

  #     it "can be filtered by a category" do
  #       visit_component

  #       within ".filters .category_id_check_boxes_tree_filter" do
  #         uncheck "All"
  #         check category.name[I18n.locale.to_s]
  #       end

  #       expect(page).to have_css(".card--solution", count: 1)
  #     end

  #     it "can be filtered by two categories" do
  #       visit_component

  #       within ".filters .category_id_check_boxes_tree_filter" do
  #         uncheck "All"
  #         check category.name[I18n.locale.to_s]
  #         check category2.name[I18n.locale.to_s]
  #       end

  #       expect(page).to have_css(".card--solution", count: 2)
  #     end
  #   end
  # end

  # context "when using the browser history", :slow do
  #   before do
  #     create_list(:solution, 2, component: component)
  #     create_list(:solution, 2, :official, component: component)
  #     create_list(:solution, 2, :official, :accepted, component: component)
  #     create_list(:solution, 2, :official, :rejected, component: component)

  #     visit_component
  #   end

  #   it "recover filters from initial pages" do
  #     within ".filters .state_check_boxes_tree_filter" do
  #       check "Rejected"
  #     end

  #     expect(page).to have_css(".card.card--solution", count: 8)

  #     page.go_back

  #     expect(page).to have_css(".card.card--solution", count: 6)
  #   end

  #   it "recover filters from previous pages" do
  #     within ".filters .state_check_boxes_tree_filter" do
  #       check "All"
  #       uncheck "All"
  #     end
  #     within ".filters .origin_check_boxes_tree_filter" do
  #       uncheck "All"
  #     end

  #     within ".filters .origin_check_boxes_tree_filter" do
  #       check "Official"
  #     end

  #     within ".filters .state_check_boxes_tree_filter" do
  #       check "Accepted"
  #     end

  #     expect(page).to have_css(".card.card--solution", count: 2)

  #     page.go_back

  #     expect(page).to have_css(".card.card--solution", count: 6)

  #     page.go_back

  #     expect(page).to have_css(".card.card--solution", count: 8)

  #     page.go_forward

  #     expect(page).to have_css(".card.card--solution", count: 6)
  #   end
  # end
end
