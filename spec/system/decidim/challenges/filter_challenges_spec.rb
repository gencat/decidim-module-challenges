# frozen_string_literal: true

require "spec_helper"

describe "Filter Challenges", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:category) { create :category, participatory_space: participatory_process }
  let!(:scope) { create :scope, organization: organization }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization: organization, scope: scope) }

  describe "when filtering challenges by SCOPE" do
    let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
    let!(:scope_2) { create :scope, organization: participatory_process.organization }

    before do
      create_list(:challenge, 2, component: component, scope: scope)
      create(:challenge, component: component, scope: scope_2)
      create(:challenge, component: component, scope: nil)
      visit_component
    end

    it "can be filtered by scope" do
      within "form.new_filter" do
        expect(page).to have_content(/Scope/i)
      end
    end

    context "when selecting the global scope" do
      it "lists the filtered challenges", :slow do
        within ".filters .with_any_scope_check_boxes_tree_filter" do
          uncheck "All"
          check "Global"
        end

        expect(page).to have_css(".card--challenge", count: 1)
        expect(page).to have_content("1 CHALLENGE")
      end
    end

    context "when selecting one scope" do
      it "lists the filtered challenges", :slow do
        within ".filters .with_any_scope_check_boxes_tree_filter" do
          uncheck "All"
          check scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card--challenge", count: 2)
        expect(page).to have_content("2 CHALLENGES")
      end
    end

    context "when selecting the global scope and another scope" do
      it "lists the filtered challenges", :slow do
        within ".filters .with_any_scope_check_boxes_tree_filter" do
          uncheck "All"
          check "Global"
          check scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card--challenge", count: 3)
        expect(page).to have_content("3 CHALLENGES")
      end
    end

    context "when unselecting the selected scope" do
      it "lists the filtered challenges" do
        within ".filters .with_any_scope_check_boxes_tree_filter" do
          uncheck "All"
          check scope.name[I18n.locale.to_s]
          check "Global"
          uncheck scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card--challenge", count: 1)
        expect(page).to have_content("1 CHALLENGE")
      end
    end

    context "when process is related to a scope" do
      let(:participatory_process) { scoped_participatory_process }

      it "cannot be filtered by scope" do
        visit_component

        within "form.new_filter" do
          expect(page).to have_no_content(/Scope/i)
        end
      end

      context "with subscopes" do
        let!(:subscopes) { create_list :subscope, 5, parent: scope }

        it "can be filtered by scope" do
          visit_component

          within "form.new_filter" do
            expect(page).to have_content(/Scope/i)
          end
        end
      end
    end
  end

  describe "when filtering challenges by STATE" do
    it "can be filtered by state" do
      visit_component

      within "form.new_filter" do
        expect(page).to have_content(/State/i)
      end
    end

    it "lists proposal challenges" do
      create(:challenge, :proposal, component: component, scope: scope)
      visit_component

      within ".filters .with_any_state_check_boxes_tree_filter" do
        check "All"
        uncheck "All"
        check "Proposal"
      end

      expect(page).to have_css(".card--challenge", count: 1)
      expect(page).to have_content("1 CHALLENGE")

      within ".card--challenge" do
        expect(page).to have_content("PROPOSAL")
      end
    end

    it "lists the filtered challenges" do
      create(:challenge, :execution, component: component, scope: scope)
      visit_component

      within ".filters .with_any_state_check_boxes_tree_filter" do
        check "All"
        uncheck "All"
        check "Execution"
      end

      expect(page).to have_css(".card--challenge", count: 1)
      expect(page).to have_content("1 CHALLENGE")

      within ".card--challenge" do
        expect(page).to have_content("EXECUTION")
      end
    end
  end

  describe "when filtering challenges by SDG" do
    context "when the participatory_space does NOT contain an SDGs component" do
      before do
        visit_component
      end

      it "the filter is not rendered" do
        expect(page).not_to have_css(".filters__section.sdgs-filter")
      end
    end

    context "when the participatory_space DOES contain an SDGs component" do
      let!(:sdgs_component) { create(:component, participatory_space: participatory_process, manifest_name: "sdgs") }

      before do
        create_list(:challenge, 2, component: component, sdg_code: :no_poverty)
        create(:challenge, component: component, sdg_code: :zero_hunger)
        create(:challenge, component: component, sdg_code: :good_health)
        create(:challenge, component: component, sdg_code: nil)
        visit_component
      end

      it "the filter is rendered" do
        expect(page).to have_css(".filters__section.sdgs-filter")
      end

      context "when NOT selecting any SDG" do
        it "lists all the challenges" do
          expect(page).to have_css(".card--challenge", count: 5)
          expect(page).to have_content("5 CHALLENGES")
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

        it "lists the challenges with the selected SDGs" do
          expect(page).to have_css(".card--challenge", count: 3)
          expect(page).to have_content("3 CHALLENGES")
        end
      end
    end
  end

  context "when filtering challenges by CATEGORY" do
    let!(:challenge) { create(:challenge, component: component, category: category) }

    before do
      login_as user, scope: :user
      visit_component
    end

    it "can be filtered by category" do
      within ".filters .with_any_category_check_boxes_tree_filter" do
        uncheck "All"
        check category.name[I18n.locale.to_s]
      end

      expect(page).to have_css(".card--challenge", count: 1)
    end

    it "works with 'back to list' link" do
      within ".filters .with_any_category_check_boxes_tree_filter" do
        uncheck "All"
        check category.name[I18n.locale.to_s]
      end

      expect(page).to have_css(".card--challenge", count: 1)

      page.find(".card--challenge .card__link").click

      click_link "Return to list"

      expect(page).to have_css(".card--challenge", count: 1)
    end
  end
end
