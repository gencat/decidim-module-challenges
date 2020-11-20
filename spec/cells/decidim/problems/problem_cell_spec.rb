# frozen_string_literal: true

require "spec_helper"

module Decidim::Problems
  describe ProblemCell, type: :cell do
    controller Decidim::Problems::ProblemsController

    let!(:problem) { create(:problem) }

    context "when rendering" do
      it "renders the card" do
        html = cell("decidim/problems/problem", problem).call
        expect(html).to have_css(".card--problem")
      end
    end
  end
end
