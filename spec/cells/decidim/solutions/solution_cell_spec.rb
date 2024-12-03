# frozen_string_literal: true

require "spec_helper"

module Decidim::Solutions
  describe SolutionCell, type: :cell do
    controller Decidim::Solutions::SolutionsController

    let(:description) do
      Decidim::Faker::Localized.sentence
    end

    let!(:solution) { create(:solution, description:) }
    let!(:solution_title) { translated(solution.title) }
    let(:html) { cell("decidim/solutions/solution_g", solution, context: { show_space: }).call }
    let!(:solution_description) { translated(solution.description) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(html).to have_css(".card__list")
      end

      it "renders the solution description" do
        expect(html).to have_content(solution_description)
      end

      it "renders the solution title" do
        expect(html).to have_content(solution_title)
      end
    end
  end
end
