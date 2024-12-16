# frozen_string_literal: true

require "spec_helper"

module Decidim::Solutions
  describe SolutionCell, type: :cell do
    controller Decidim::Solutions::SolutionsController

    let(:description) do
      Decidim::Faker::Localized.sentence
    end

    let(:model) { solution }
    let(:solution_description) { translated(solution.description) }
    let(:solution_title) { translated(solution.title) }
    let(:sdg_code) { :sustainable_cities }
    let(:show_space) { false }
    let(:cell_html) { cell("decidim/solutions/solution_g", solution, context: { show_space: }).call }

    shared_examples "rendering the cell" do
      before do
        challenge.update_columns(sdg_code:)
      end

      it "renders the card" do
        expect(cell_html).to have_css(".card__list")
        expect(cell_html).to have_content(solution_description)
        expect(cell_html).to have_content(solution_title)
        expect(cell_html).to have_content(t(sdg_code, scope: "decidim.sdgs.names"))
      end
    end
  end
end
