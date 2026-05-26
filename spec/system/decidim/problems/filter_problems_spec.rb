# frozen_string_literal: true

require "spec_helper"

describe "Filter Problems", :slow do
  include_context "with a component"
  let(:manifest_name) { "problems" }

  let!(:user) { create(:user, :confirmed, organization:) }

  # describe "when filtering problems by challenge" do
  pending "finds the problems associated with the given challenge"
  # end

  describe "when filtering problems by STATE" do
    it "can be filtered by state" do
      visit_component

      within "form.new_filter" do
        expect(page).to have_content(/State/i)
      end
    end

    it "lists proposal problems" do
      create(:problem, :proposal, component:)
      visit_component

      within "#dropdown-menu-filters div.filter-container", text: "State" do
        check "All"
        uncheck "All"
        check "Proposal"
      end

      expect(page).to have_css(".card__list", count: 1)
      expect(page).to have_content("1 problem")

      within ".card__list" do
        expect(page).to have_content("Proposal")
      end
    end

    it "lists the filtered problems" do
      create(:problem, :execution, component:)
      visit_component

      within "#dropdown-menu-filters div.filter-container", text: "State" do
        check "All"
        uncheck "All"
        check "Execution"
      end

      expect(page).to have_css(".card__list", count: 1)
      expect(page).to have_content("1 problem")

      within ".card__list" do
        expect(page).to have_content("Execution")
      end
    end
  end

  describe "when filtering problems by SDG" do
    context "when the participatory_space does NOT contain an SDGs component" do
      before do
        visit_component
      end

      it "the filter is not rendered" do
        within "form.new_filter" do
          expect(page).to have_no_content("SDGs")
        end
      end
    end
  end

  # context "when using the browser history", :slow do
  #   before do
  #     create_list(:problem, 2, component: component)
  #     create_list(:problem, 2, :official, component: component)
  #     create_list(:problem, 2, :official, :accepted, component: component)
  #     create_list(:problem, 2, :official, :rejected, component: component)

  #     visit_component
  #   end

  #     it "the filter is rendered" do
  #       expect(page).to have_content("SDGs")
  #     end

  #     context "when NOT selecting any SDG" do
  #       it "lists all the problems" do
  #         expect(page).to have_css(".card__list", count: 5)
  #         expect(page).to have_content("5 problems")
  #       end
  #     end

  #     context "when selecting some SDGs" do
  #       before do

  #         find(".filters__section.sdgs-filter button").click_on
  #         expect(page).to have_field("#sdgs-modal")

  #         within "#sdgs-modal" do
  #           find('.sdg-cell[data-value="no_poverty"]').click_on
  #           find('.sdg-cell[data-value="good_health"]').click_on
  #           find(".reveal__footer a.button").click_on
  #         end
  #       end

  #       it "lists the problems with the selected SDGs" do
  #         expect(page).to have_field(".card__list", count: 3)
  #         expect(page).to have_content("3 PROBLEMS")
  #       end
  #     end
  #   end
  # end
end
