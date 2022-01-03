# frozen_string_literal: true

require "spec_helper"

describe "Solutions", type: :system do
  include ActionView::Helpers::SanitizeHelper

  include_context "with a component"
  let(:manifest_name) { "solutions" }

  describe "#show" do
    context "when a solution has contents" do
      let!(:solution) { create(:solution, component: component) }

      before do
        visit_component
        click_link translated(solution.title)
      end

      it "does render the contents" do
        expect(page).to have_content("Indicators")
        expect(page).to have_content(strip_tags(translated(solution.indicators)))
        expect(page).to have_content("Beneficiaries")
        expect(page).to have_content(strip_tags(translated(solution.beneficiaries)))
        expect(page).to have_content("Requeriments")
        expect(page).to have_content(strip_tags(translated(solution.requirements)))
        expect(page).to have_content("FINANCING TYPE")
        expect(page).to have_content(strip_tags(translated(solution.financing_type)))
        expect(page).to have_content("Objectives")
        expect(page).to have_content(strip_tags(translated(solution.objectives)))
        expect(page).to have_content("Keywords")
        expect(page).to have_content(translated(solution.tags))
      end
    end

    context "when a solution optional contents are empty" do
      let!(:solution) { create(:solution, component: component, indicators: {}, beneficiaries: {}, requirements: {}, financing_type: {}, objectives: {}, tags: {}) }

      before do
        visit_component
        click_link translated(solution.title)
      end

      it "does not render titles for empty contents" do
        expect(page).not_to have_content("Indicators")
        expect(page).not_to have_content("Beneficiaries")
        expect(page).not_to have_content("Requeriments")
        expect(page).not_to have_content("FINANCING TYPE")
        expect(page).not_to have_content("Objectives")
        expect(page).not_to have_content("Keywords")
      end
    end
  end
end
