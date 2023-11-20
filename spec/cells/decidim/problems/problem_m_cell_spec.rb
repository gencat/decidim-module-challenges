# frozen_string_literal: true

require "spec_helper"

module Decidim::Problems
  describe ProblemCell, type: :cell do
    controller Decidim::Problems::ProblemsController

    let(:description) do
      Decidim::Faker::Localized.sentence
    end
    let!(:problem) { create :problem, description: description }
    let(:model) { problem }
    let(:cell_html) { cell("decidim/problems/problem_m", problem, context: { show_space: show_space }).call }
    let!(:problem_title) { translated(problem.title) }
    let!(:problem_description) { translated(problem.description) }
    let!(:challenge_title) { translated(problem.challenge.title) }

    context "when rendering" do
      let(:show_space) { false }

      it "renders the card" do
        expect(cell_html).to have_css(".card--problem")
      end

      it "renders the problem title" do
        expect(cell_html).to have_content(problem_title)
      end

      it "renders the problem description" do
        expect(cell_html).to have_content(problem_description)
      end

      it "renders the challenge title" do
        expect(cell_html).to have_content(challenge_title)
      end
    end
  end
end
