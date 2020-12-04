# frozen_string_literal: true

require "spec_helper"
require_relative "../search_scopes_examples"

module Decidim
  module Solutions
    describe SolutionSearch do
      let!(:challenge) { create(:challenge) }
      let!(:problem) { create(:problem, challenge: challenge) }
      let(:component) { create(:solutions_component, organization: challenge.component.organization) }
      let(:participatory_process) { component.participatory_space }
      let!(:solutions_list) { create_list(:solution, 3, component: component, problem: problem) }

      describe "results" do
        subject do
          described_class.new(
            component: component,
            search_text: search_text,
            state: states,
            related_to: related_to,
            territorial_scope_id: territorial_scope_ids,
            category_id: category_ids,
            sdgs_codes: sdgs_codes
          ).results
        end

        let(:search_text) { nil }
        let(:related_to) { nil }
        let(:states) { nil }
        let(:territorial_scope_ids) { nil }
        let(:category_ids) { nil }
        let(:sdgs_codes) { nil }

        it "only includes solutions from the given component" do
          other_solution = create(:solution, problem: problem)

          expect(subject).to match_array(solutions_list)
          expect(subject).not_to include(other_solution)
        end

        describe "search_text filter" do
          let(:search_text) { "dog" }

          it "returns the solutions containing the search in the title or the body" do
            dog_solution = create(:solution, title: { I18n.locale => "A dog" }, component: component)

            expect(subject).to include(dog_solution)
            expect(subject.size).to eq(1)
          end
        end

        describe "challenge territorial scopes" do
          include_context "with example scopes"

          let(:challenges_component) { create(:challenges_component, participatory_space: component.participatory_space) }
          let!(:challenge_without_scope) { create(:challenge, component: challenges_component, scope: nil) }
          let!(:challenge_1) { create(:challenge, component: challenges_component, scope: scope_1) }
          let!(:challenge_2) { create(:challenge, component: challenges_component, scope: scope_2) }
          let!(:challenge_3) { create(:challenge, component: challenges_component, scope: subscope_1) }

          let(:problems_component) { create(:problems_component, participatory_space: component.participatory_space) }
          let!(:problem_without_scope) { create(:problem, component: problems_component, challenge: challenge_without_scope) }
          let!(:problem_1) { create(:problem, component: problems_component, challenge: challenge_1) }
          let!(:problem_2) { create(:problem, component: problems_component, challenge: challenge_2) }
          let!(:problem_3) { create(:problem, component: problems_component, challenge: challenge_3) }

          let(:resources_list) { solutions_list }
          let!(:resource_without_scope) { create(:solution, component: component, problem: problem_without_scope) }
          let!(:resource_1) { create(:solution, component: component, problem: problem_1) }
          let!(:resource_2) { create(:solution, component: component, problem: problem_2) }
          let!(:resource_3) { create(:solution, component: component, problem: problem_3) }

          context "with sectorial_scope_ids" do
            include_examples "search scope filter", "territorial_scope_ids"
          end
        end

        describe "SDGs filter" do
          context "when none is selected" do
            it "does not apply the filter" do
              expect(subject).to match_array(solutions_list)
            end
          end

          context "when one SDG is selected" do
            let(:sdg_code) { :partnership }
            let!(:challenge_w_sdg) { create(:challenge, component: challenge.component, sdg_code: sdg_code) }
            let!(:problem_w_sdg) { create(:problem, component: problem.component, challenge: challenge_w_sdg) }
            let!(:solution_w_sdg) { create(:solution, component: component, problem: problem_w_sdg) }
            let(:sdgs_codes) { [sdg_code] }

            it "returns the solutions associated to the given SDG" do
              expect(subject.pluck(:id)).to match_array([solution_w_sdg.id])
            end
          end
        end

        describe "related_to filter" do
          context "when filtering by related to solutions" do
            #   let(:related_to) { 'Decidim::Meetings::Meeting'.underscore }
            #   let(:solutions_component) { create(:component, manifest_name: 'solutions', participatory_space: participatory_process) }
            #   let(:solution) { create :solution, component: solutions_component }

            it "returns only solutions related to solutions"
            #     related_solution = create(:solution, :accepted, component: component)
            #     related_solution_2 = create(:solution, :accepted, component: component)
            #     create_list(:solution, 3, component: component)
            #     solution.link_resources([related_solution], 'solutions_from_solution')
            #     related_solution_2.link_resources([solution], 'solutions_from_solution')

            #     expect(subject).to match_array([related_solution, related_solution_2])
            #   end
          end

          context "when filtering by related to resources" do
            #   let(:related_to) { 'Decidim::DummyResources::DummyResource'.underscore }
            #   let(:dummy_component) { create(:component, manifest_name: 'dummy', participatory_space: participatory_process) }
            #   let(:dummy_resource) { create :dummy_resource, component: dummy_component }

            it "returns only solutions related to results"
            #     related_solution = create(:solution, :accepted, component: component)
            #     related_solution_2 = create(:solution, :accepted, component: component)
            #     create_list(:solution, 3, component: component)
            #     dummy_resource.link_resources([related_solution], 'included_solutions')
            #     related_solution_2.link_resources([dummy_resource], 'included_solutions')

            #     expect(subject).to match_array([related_solution, related_solution_2])
            #   end
          end
        end
      end
    end
  end
end
