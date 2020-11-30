# frozen_string_literal: true

require "spec_helper"

module Decidim::Solutions
  describe SolutionCell, type: :cell do
    controller Decidim::Solutions::SolutionsController

    let!(:solution) { create(:solution) }

    context "when rendering" do
      it "renders the card" do
        html = cell("decidim/solutions/solution", solution).call
        expect(html).to have_css(".card--solution")
      end
    end
  end
end