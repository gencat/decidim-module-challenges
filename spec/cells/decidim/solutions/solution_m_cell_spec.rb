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
    let(:challenge_title) { translated(challenge.title) }
    let(:sdg_code) { :sustainable_cities }
    let(:show_space) { false }
    let(:cell_html) { cell("decidim/solutions/solution_m", solution, context: { show_space: show_space }).call }

    shared_examples "rendering the cell" do
      before do
        challenge.update_columns(sdg_code: sdg_code)
      end

      it "renders the card" do
        expect(cell_html).to have_css(".card--solution")
        expect(cell_html).to have_content(solution_description)
        expect(cell_html).to have_content(solution_title)
        expect(cell_html).to have_content(challenge_title)
        expect(cell_html).to have_content(t(sdg_code, scope: "decidim.sdgs.names"))
      end
    end

    context "when the parent is a problem" do
      let!(:solution) { create :solution, description: description }
      let(:challenge) { solution.problem.challenge }
      let(:problem_title) { translated(solution.problem.title) }

      it_behaves_like "rendering the cell"

      it "renders the problem title" do
        expect(cell_html).to have_content(problem_title)
      end
    end

    context "when the parent is a challenge" do
      let(:challenge) { create :challenge }
      let!(:solution) { create :solution, description: description, problem: nil, challenge: challenge }

      it_behaves_like "rendering the cell"

      it "renders the challenge title" do
        expect(cell_html).to have_content(translated(challenge.title))
      end
    end
  end
end
