# frozen_string_literal: true

require "spec_helper"
require_relative "../filter_resources_by_scope_examples"

describe "Filter Problems", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "problems" }

  let!(:category) { create :category, participatory_space: participatory_process }
  let!(:scope) { create :scope, organization: organization }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization: organization, scope: scope) }

  # describe "when filtering problems by challenge" do
  pending "finds the problems associated with the given challenge"
  # end

  describe "when filtering problems by sectorial and technological scopes" do
    before do
      create_list(:problem, 2, component: component, sectorial_scope: scope, technological_scope: scope)
      create(:problem, component: component, sectorial_scope: scope_2, technological_scope: scope_2)
      create(:problem, component: component, sectorial_scope: nil, technological_scope: nil)
    end

    include_examples "when filtering resources by a scope", "PROBLEM", ".card--problem", ".with_any_sectorial_scope_id_check_boxes_tree_filter"
    include_examples "when filtering resources by a scope", "PROBLEM", ".card--problem", ".with_any_technological_scope_id_check_boxes_tree_filter"
  end

  describe "when filtering problems by challenge's territorial scopes" do
    before do
      challenges_component = create(:challenges_component, participatory_space: participatory_process)
      challenge = create(:challenge, component: challenges_component, scope: scope)
      create_list(:problem, 2, component: component, challenge: challenge)
      challenge_2 = create(:challenge, component: challenges_component, scope: scope_2)
      create(:problem, component: component, challenge: challenge_2)
      challenge_no_scope = create(:challenge, component: challenges_component, scope: nil)
      create(:problem, component: component, challenge: challenge_no_scope)
    end

    include_examples "when filtering resources by a scope", "PROBLEM", ".card--problem", ".with_any_territorial_scope_id_check_boxes_tree_filter"
  end

  describe "when filtering problems by STATE" do
    it "can be filtered by state" do
      visit_component

      within "form.new_filter" do
        expect(page).to have_content(/State/i)
      end
    end

    it "lists proposal problems" do
      create(:problem, :proposal, component: component)
      visit_component

      within ".filters .with_any_state_check_boxes_tree_filter" do
        check "All"
        uncheck "All"
        check "Proposal"
      end

      expect(page).to have_css(".card--problem", count: 1)
      expect(page).to have_content("1 PROBLEM")

      within ".card--problem" do
        expect(page).to have_content("PROPOSAL")
      end
    end

    it "lists the filtered problems" do
      # create(:problem, :execution, component: component, scope: scope)
      create(:problem, :execution, component: component)
      visit_component

      within ".filters .with_any_state_check_boxes_tree_filter" do
        check "All"
        uncheck "All"
        check "Execution"
      end

      expect(page).to have_css(".card--problem", count: 1)
      expect(page).to have_content("1 PROBLEM")

      within ".card--problem" do
        expect(page).to have_content("EXECUTION")
      end
    end
  end

  describe "when filtering problems by SDG" do
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

      before do
        challenge = create(:challenge, component: challenges_component, sdg_code: :no_poverty)
        create_list(:problem, 2, component: component, challenge: challenge)
        challenge = create(:challenge, component: challenges_component, sdg_code: :zero_hunger)
        create(:problem, component: component, challenge: challenge)
        challenge = create(:challenge, component: challenges_component, sdg_code: :good_health)
        create(:problem, component: component, challenge: challenge)
        challenge = create(:challenge, component: challenges_component)
        create(:problem, component: component, challenge: challenge)
        visit_component
      end

      it "the filter is rendered" do
        expect(page).to have_css(".filters__section.sdgs-filter")
      end

      context "when NOT selecting any SDG" do
        it "lists all the problems" do
          expect(page).to have_css(".card--problem", count: 5)
          expect(page).to have_content("5 PROBLEMS")
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

        it "lists the problems with the selected SDGs" do
          expect(page).to have_css(".card--problem", count: 3)
          expect(page).to have_content("3 PROBLEMS")
        end
      end
    end
  end

  # context "when filtering problems by CATEGORY", :slow do
  #   context "when the user is logged in" do
  #     let!(:category2) { create :category, participatory_space: participatory_process }
  #     let!(:category3) { create :category, participatory_space: participatory_process }
  #     let!(:problem1) { create(:problem, component: component, category: category) }
  #     let!(:problem2) { create(:problem, component: component, category: category2) }
  #     let!(:problem3) { create(:problem, component: component, category: category3) }

  #     before do
  #       login_as user, scope: :user
  #     end

  #     it "can be filtered by a category" do
  #       visit_component

  #       within ".filters .category_id_check_boxes_tree_filter" do
  #         uncheck "All"
  #         check category.name[I18n.locale.to_s]
  #       end

  #       expect(page).to have_css(".card--problem", count: 1)
  #     end

  #     it "can be filtered by two categories" do
  #       visit_component

  #       within ".filters .category_id_check_boxes_tree_filter" do
  #         uncheck "All"
  #         check category.name[I18n.locale.to_s]
  #         check category2.name[I18n.locale.to_s]
  #       end

  #       expect(page).to have_css(".card--problem", count: 2)
  #     end
  #   end
  # end

  # context "when using the browser history", :slow do
  #   before do
  #     create_list(:problem, 2, component: component)
  #     create_list(:problem, 2, :official, component: component)
  #     create_list(:problem, 2, :official, :accepted, component: component)
  #     create_list(:problem, 2, :official, :rejected, component: component)

  #     visit_component
  #   end

  #   it "recover filters from initial pages" do
  #     within ".filters .state_check_boxes_tree_filter" do
  #       check "Rejected"
  #     end

  #     expect(page).to have_css(".card.card--problem", count: 8)

  #     page.go_back

  #     expect(page).to have_css(".card.card--problem", count: 6)
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

  #     expect(page).to have_css(".card.card--problem", count: 2)

  #     page.go_back

  #     expect(page).to have_css(".card.card--problem", count: 6)

  #     page.go_back

  #     expect(page).to have_css(".card.card--problem", count: 8)

  #     page.go_forward

  #     expect(page).to have_css(".card.card--problem", count: 6)
  #   end
  # end
end
