# frozen_string_literal: true

require "spec_helper"

describe "Filter Challenges", :slow do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:user) { create(:user, :confirmed, organization:) }

  describe "when filtering challenges by STATE" do
    it "can be filtered by state" do
      visit_component

      within "form.new_filter" do
        expect(page).to have_content(/State/i)
      end
    end

    it "lists proposal challenges" do
      create(:challenge, :proposal, component:)
      visit_component

      within "#dropdown-menu-filters div.filter-container", text: "State" do
        check "All"
        uncheck "All"
        check "Proposal"
      end

      expect(page).to have_css(".card__list", count: 1)
      expect(page).to have_content("1 challenge")

      within ".card__list" do
        expect(page).to have_content("Proposal")
      end
    end

    it "lists the filtered challenges" do
      create(:challenge, :execution, component:)
      visit_component

      within "#dropdown-menu-filters div.filter-container", text: "State" do
        check "All"
        uncheck "All"
        check "Execution"
      end

      expect(page).to have_css(".card__list", count: 1)
      expect(page).to have_content("1 challenge")

      within ".card__list" do
        expect(page).to have_content("Execution")
      end
    end
  end

  describe "when filtering challenges by SDG" do
    context "when the participatory_space does NOT contain an SDGs component" do
      before do
        visit_component
      end

      it "the filter is not rendered" do
        expect(page).to have_no_css(".filters__section.sdgs-filter")
      end
    end

    context "when the participatory_space DOES contain an SDGs component" do
      let!(:sdgs_component) { create(:component, participatory_space: participatory_process, manifest_name: "sdgs") }

      before do
        create_list(:challenge, 2, component:, sdg_code: :no_poverty)
        create(:challenge, component:, sdg_code: :zero_hunger)
        create(:challenge, component:, sdg_code: :good_health)
        create(:challenge, component:, sdg_code: nil)
        visit_component
      end

      it "the filter is rendered" do
        expect(page).to have_css(".filters__section.sdgs-filter")
      end

      context "when NOT selecting any SDG" do
        it "lists all the challenges" do
          expect(page).to have_css(".card__list", count: 5)
          expect(page).to have_content("5 challenges")
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
          expect(page).to have_css(".card__list", count: 3)
          expect(page).to have_content("3 challenges")
        end
      end
    end
  end
end
