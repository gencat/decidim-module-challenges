# frozen_string_literal: true

require "spec_helper"
require_relative "../filter_resources_by_scope_examples"

describe "Filter Solutions", :slow do
  include_context "with a component"
  let(:manifest_name) { "solutions" }

  let!(:scope) { create(:scope, organization:) }
  let!(:user) { create(:user, :confirmed, organization:) }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization:, scope:) }

  describe "when filtering solutions by challenge's territorial scopes" do
    before do
      challenges_component = create(:challenges_component, participatory_space: participatory_process)
      problems_component = create(:problems_component, participatory_space: participatory_process)

      challenge = create(:challenge, component: challenges_component, scope:)
      problem = create(:problem, component: problems_component, challenge:)
      create_list(:solution, 2, component:, problem:)

      challenge_2 = create(:challenge, component: challenges_component, scope: scope_2)
      problem_2 = create(:problem, component: problems_component, challenge: challenge_2)
      create(:solution, component:, problem: problem_2)

      challenge_no_scope = create(:challenge, component: challenges_component, scope: nil)
      problem_no_scope = create(:problem, component: problems_component, challenge: challenge_no_scope)
      create(:solution, component:, problem: problem_no_scope)
    end

    include_examples "when filtering resources by a scope", "Territorial scope", ".card__list"
  end

  describe "when filtering solutions by SDG" do
    context "when the participatory_space does NOT contain an SDGs component" do
      before do
        visit_component
      end

      it "the filter is not rendered" do
        expect(page).to have_no_css(".filters__section.sdgs-filter")
      end
    end

    context "when the participatory_space DOES contain an SDGs component" do
      let!(:sdgs_component) { create(:sdgs_component, participatory_space: participatory_process) }
      let!(:challenges_component) { create(:challenges_component, participatory_space: participatory_process) }
      let!(:problems_component) { create(:problems_component, participatory_space: participatory_process) }

      before do
        challenge = create(:challenge, component: challenges_component, sdg_code: :no_poverty)
        problem = create(:problem, component: problems_component, challenge:)
        create_list(:solution, 2, component:, problem:, challenge:)
        challenge = create(:challenge, component: challenges_component, sdg_code: :zero_hunger)
        problem = create(:problem, component: problems_component, challenge:)
        create(:solution, component:, problem:, challenge:)
        challenge = create(:challenge, component: challenges_component, sdg_code: :good_health)
        problem = create(:problem, component: problems_component, challenge:)
        create(:solution, component:, problem:, challenge:)
        challenge = create(:challenge, component: challenges_component)
        problem = create(:problem, component: problems_component, challenge:)
        create(:solution, component:, problem:, challenge:)
        visit_component
      end

      it "the filter is rendered" do
        expect(page).to have_css(".filters__section.sdgs-filter")
      end

      context "when NOT selecting any SDG" do
        it "lists all the solutions" do
          expect(page).to have_css(".card__list", count: 5)
          expect(page).to have_content("5 solutions")
        end
      end

      context "when selecting some SDGs" do
        before do
          find(".filters__section.sdgs-filter button").click
          expect(page).to have_css("#sdgs-modal")

          within "#sdgs-modal" do
            find('.sdg-cell[data-value="no_poverty"]').click
            find('.sdg-cell[data-value="good_health"]').click
            find(".reveal__footer a.button").click
          end
        end

        it "lists the solutions with the selected SDGs" do
          expect(page).to have_css(".card__list", count: 3)
          expect(page).to have_content("3 solutions")
        end
      end
    end
  end

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

  #     expect(page).to have_field(".card.card--solution", count: 8)

  #     page.go_back

  #     expect(page).to have_field(".card.card--solution", count: 6)
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

  #     expect(page).to have_field(".card.card--solution", count: 2)

  #     page.go_back

  #     expect(page).to have_field(".card.card--solution", count: 6)

  #     page.go_back

  #     expect(page).to have_field(".card.card--solution", count: 8)

  #     page.go_forward

  #     expect(page).to have_field(".card.card--solution", count: 6)
  #   end
  # end
end
