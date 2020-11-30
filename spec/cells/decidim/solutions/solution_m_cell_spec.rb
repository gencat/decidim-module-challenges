# frozen_string_literal: true

require "spec_helper"

module Decidim::Solutions
  describe SolutionCell, type: :cell do
    controller Decidim::Solutions::SolutionsController

    let!(:solution) { create(:solution) }
    let(:model) { solution }
    let(:cell_html) { cell("decidim/solutions/solution_m", solution, context: { show_space: show_space }).call }

    it_behaves_like "has space in m-cell"

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(cell_html).to have_css(".card--solution")
      end
    end
  end
end