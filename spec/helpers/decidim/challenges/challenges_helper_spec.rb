# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe ChallengesHelper do
    subject { helper.challenge_associated_solutions(challenge) }

    let(:challenge) { create(:challenge) }
    let(:participatory_space) { challenge.participatory_space }
    let(:solutions_component) { create(:solutions_component, participatory_space: challenge.participatory_space) }

    context "when solutions are associated to problems" do
      let(:problems_component) { create(:problems_component, participatory_space: challenge.participatory_space) }
      let(:problem) { create :problem, component: problems_component, challenge: challenge }
      let!(:solution) { create(:solution, component: solutions_component, problem: problem) }

      it "shows solutions if the problem is published" do
        expect(subject).to include(solution)
      end

      it "hides solutions if the problem is published but the solutions are NOT published" do
        solution.update_attribute(:published_at, nil)
        expect(subject).to be_empty
      end

      it "hides solutions if the solutions component is NOT published" do
        solutions_component.update_attribute(:published_at, nil)
        expect(subject).to be_empty
      end

      it "hides solutions if the problems component is NOT published" do
        solution.update_attribute(:published_at, nil)
        expect(subject).to be_empty
      end
      it "hides solutions if the problem is NOT published" do
        problem.update_attribute(:published_at, nil)
        expect(subject).to be_empty
      end
    end

    context "when solutions are associated to challenges" do
      let!(:solution) { create(:solution, component: solutions_component, challenge: challenge) }

      it "shows solutions if challenge is published" do
        expect(subject).to include(solution)
      end

      it "hides solutions if the solutions component is NOT published" do
        solutions_component.update_attribute(:published_at, nil)
        expect(subject).to be_empty
      end

      it "hides solutions NOT published" do
        solution.update_attribute(:published_at, nil)
        expect(subject).to be_empty
      end
    end
  end
end
