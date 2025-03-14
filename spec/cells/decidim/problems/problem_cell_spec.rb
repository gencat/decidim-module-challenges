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
    let!(:problem_title) { translated(problem.title) }
    let!(:problem_description) { translated(problem.description) }
    let(:html) { cell("decidim/problems/problem", problem, context: { show_space: }).call }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(html).to have_css(".card__list")
      end

      it "renders the problem title" do
        expect(html).to have_content(problem_title)
      end

      it "renders the problem description" do
        expect(html).to have_content(problem_description)
      end
    end
  end
end
