# frozen_string_literal: true

require "spec_helper"

module Decidim::Solutions
  describe SolutionCell, type: :cell do
    controller Decidim::Solutions::SolutionsController

    let(:description) do
      Decidim::Faker::Localized.sentence
    end

    let!(:solution) { create :solution, description: description }
    let!(:solution_title) { translated(solution.title) }
    let(:html) { cell("decidim/solutions/solution", solution, context: { show_space: show_space }).call }
    let!(:solution_description) { translated(solution.description) }
    let!(:problem_title) { translated(solution.problem.title) }
    let!(:challenge_title) { translated(solution.problem.challenge.title) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(html).to have_css(".card--solution")
      end

      it "renders the solution description" do
        expect(html).to have_content(solution_description)
      end

      it "renders the solution title" do
        expect(html).to have_content(solution_title)
      end

      it "renders the problem title" do
        expect(html).to have_content(problem_title)
      end

      it "renders the challenge title" do
        expect(html).to have_content(challenge_title)
      end
    end
  end
end
