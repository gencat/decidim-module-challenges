# frozen_string_literal: true

require "spec_helper"

describe "Filter Challenges", :slow do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:scope) { create(:scope, organization:) }
  let!(:user) { create(:user, :confirmed, organization:) }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization:, scope:) }

  describe "when filtering challenges by SCOPE" do
    let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
    let!(:scope_2) { create(:scope, organization: participatory_process.organization) }

    before do
      create_list(:challenge, 2, component:, scope:)
      create(:challenge, component:, scope: scope_2)
      create(:challenge, component:, scope: nil)
      visit_component
    end

    it "can be filtered by scope" do
      within "form.new_filter" do
        expect(page).to have_content(/Scope/i)
      end
    end

    context "when selecting the global scope" do
      it "lists the filtered challenges", :slow do
        within "#dropdown-menu-filters div.filter-container", text: "Scope" do
          uncheck "All"
          check "Global"
        end

        expect(page).to have_css(".card__list", count: 1)
        expect(page).to have_content("1 challenge")
      end
    end

    context "when selecting one scope" do
      it "lists the filtered challenges", :slow do
        within "#dropdown-menu-filters div.filter-container", text: "Scope" do
          uncheck "All"
          check scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card__list", count: 2)
        expect(page).to have_content("2 challenges")
      end
    end

    context "when selecting the global scope and another scope" do
      it "lists the filtered challenges", :slow do
        within "#dropdown-menu-filters div.filter-container", text: "Scope" do
          uncheck "All"
          check "Global"
          check scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card__list", count: 3)
        expect(page).to have_content("3 challenges")
      end
    end

    context "when unselecting the selected scope" do
      it "lists the filtered challenges" do
        within "#dropdown-menu-filters div.filter-container", text: "Scope" do
          uncheck "All"
          check scope.name[I18n.locale.to_s]
          check "Global"
          uncheck scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card__list", count: 1)
        expect(page).to have_content("1 challenge")
      end
    end

    # context "when process is related to a scope" do
    #   let(:participatory_process) { scoped_participatory_process }

    #   it "cannot be filtered by scope" do
    #     visit_component

    #     within "form.new_filter" do
    #       expect(page).to have_no_content(/Scope/i)
    #     end
    #   end

    #   context "with subscopes" do
    #     let!(:subscopes) { create_list(:subscope, 5, parent: scope) }

    #     it "can be filtered by scope" do
    #       visit_component

    #       within "form.new_filter" do
    #         expect(page).to have_content(/Scope/i)
    #       end
    #     end
    #   end
    # end
  end

  describe "when filtering challenges by STATE" do
    it "can be filtered by state" do
      visit_component

      within "form.new_filter" do
        expect(page).to have_content(/State/i)
      end
    end

    it "lists proposal challenges" do
      create(:challenge, :proposal, component:, scope:)
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
      create(:challenge, :execution, component:, scope:)
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

  # describe "when filtering challenges by SDG" do
  #   context "when the participatory_space does NOT contain an SDGs component" do
  #     before do
  #       visit_component
  #     end

  #     it "the filter is not rendered" do
  #       expect(page).to have_no_css(".filters__section.sdgs-filter")
  #     end
  #   end

  #   context "when the participatory_space DOES contain an SDGs component" do
  #     let!(:sdgs_component) { create(:component, participatory_space: participatory_process, manifest_name: "sdgs") }

  #     before do
  #       create_list(:challenge, 2, component:, sdg_code: :no_poverty)
  #       create(:challenge, component:, sdg_code: :zero_hunger)
  #       create(:challenge, component:, sdg_code: :good_health)
  #       create(:challenge, component:, sdg_code: nil)
  #       visit_component
  #     end

  #     it "the filter is rendered" do
  #       expect(page).to have_field(".filters__section.sdgs-filter")
  #     end

  #     context "when NOT selecting any SDG" do
  #       it "lists all the challenges" do
  #         expect(page).to have_field(".card--challenge", count: 5)
  #         expect(page).to have_content("5 CHALLENGES")
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

  #       it "lists the challenges with the selected SDGs" do
  #         expect(page).to have_field(".card--challenge", count: 3)
  #         expect(page).to have_content("3 CHALLENGES")
  #       end
  #     end
  #   end
  # end
end
