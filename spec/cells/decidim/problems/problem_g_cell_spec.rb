# frozen_string_literal: true

require "spec_helper"

module Decidim::Problems
  describe ProblemCell, type: :cell do
    controller Decidim::Problems::ProblemsController

    let(:description) do
      Decidim::Faker::Localized.sentence
    end
    let!(:problem) { create(:problem, description:) }
    let(:model) { problem }
    let(:cell_html) { cell("decidim/problems/problem_g", problem, context: { show_space: }).call }
    let!(:problem_title) { translated(problem.title) }
    let!(:problem_description) { translated(problem.description) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(cell_html).to have_css(".card__list")
      end

      it "renders the problem title" do
        expect(cell_html).to have_content(problem_title)
      end

      it "renders the problem description" do
        expect(cell_html).to have_content(problem_description)
      end
    end
  end
end
