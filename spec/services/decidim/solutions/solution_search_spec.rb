# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Solutions
    describe SolutionSearch do
      let!(:challenge) { create :challenge }
      let!(:problem) { create :problem, challenge: challenge }
      let(:problem_component) { create(:component, organization: challenge.component.organization, manifest_name: "problems") }
      let(:component) { create(:component, organization: challenge.component.organization, manifest_name: "solutions") }
      let(:participatory_process) { component.participatory_space }
      let!(:solutions_list) { create_list(:solution, 3, component: component, problem: problem) }

      describe "results" do
        subject do
          described_class.new(
            component: component,
            search_text: search_text,
            state: states,
            related_to: related_to,
            scope_id: scope_ids,
            category_id: category_ids,
            sdgs_codes: sdgs_codes
          ).results
        end

        let(:search_text) { nil }
        let(:related_to) { nil }
        let(:states) { nil }
        let(:scope_ids) { nil }
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
            dog_solution = create(:solution, title: { I18n.locale => "A dog solution" }, component: component)

            expect(subject).to include(dog_solution)
            expect(subject.size).to eq(1)
          end
        end

        describe "state filter" do
          context "when filtering for default states" do
            it "returns all solutions" do
              expect(subject.size).to eq(3)
              expect(subject).to match_array(solutions_list)
            end
          end
        end

        describe "scope_id filter" do
          let(:scope_1) { create :scope, organization: component.organization }
          let(:scope_2) { create :scope, organization: component.organization }
          let(:subscope_1) { create :scope, organization: component.organization, parent: scope_1 }
          let!(:solution_1) { create(:solution, component: component, scope: scope_1, problem: problem) }
          let!(:solution_2) { create(:solution, component: component, scope: scope_2, problem: problem) }
          let!(:solution_3) { create(:solution, component: component, scope: subscope_1, problem: problem) }

          context "when a parent scope id is being sent" do
            let(:scope_ids) { [scope_1.id] }

            it "filters solutions by scope" do
              expect(subject).to match_array [solution_1, solution_3]
            end
          end

          context "when a subscope id is being sent" do
            let(:scope_ids) { [subscope_1.id] }

            it "filters solutions by scope" do
              expect(subject).to eq [solution_3]
            end
          end

          context "when multiple ids are sent" do
            let(:scope_ids) { [scope_2.id, scope_1.id] }

            it "filters solutions by scope" do
              expect(subject).to match_array [solution_1, solution_2, solution_3]
            end
          end

          context "when `global` is being sent" do
            let!(:resource_without_scope) { create(:solution, component: component, scope: nil, problem: problem) }
            let(:scope_ids) { ["global"] }

            it "returns solutions without a scope" do
              expect(subject.pluck(:id).sort).to eq(solutions_list.pluck(:id) + [resource_without_scope.id])
            end
          end

          context "when `global` and some ids is being sent" do
            let!(:resource_without_scope) { create(:solution, component: component, scope: nil, problem: problem) }
            let(:scope_ids) { ["global", scope_2.id, scope_1.id] }

            it "returns solutions without a scope and with selected scopes" do
              expect(subject.pluck(:id)).to match_array(solutions_list.pluck(:id) + [resource_without_scope.id, solution_1.id, solution_2.id, solution_3.id])
            end
          end
        end

        describe "SDGs filter" do
          context "when none is selected" do
            it "does not apply the filter" do
              expect(subject).to match_array(solutions_list)
            end
          end

          context "when one SDG is selected" do
            let(:sdg_code) { :zero_hunger }
            let!(:challenge_w_sdg) { create(:challenge, component: challenge.component, sdg_code: sdg_code) }
            let!(:problem_w_sdg) { create(:problem, component: problem_component, challenge: challenge_w_sdg) }
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
            #   let(:problems_component) { create(:component, manifest_name: 'problems', participatory_space: participatory_process) }
            #   let(:problem) { create :problem, component: problems_component }

            it "returns only solutions related to solutions"
            #     related_problem = create(:problem, :accepted, component: component)
            #     related_problem_2 = create(:problem, :accepted, component: component)
            #     create_list(:problem, 3, component: component)
            #     problem.link_resources([related_problem], 'problems_from_problem')
            #     related_problem_2.link_resources([problem], 'problems_from_problem')

            #     expect(subject).to match_array([related_problem, related_problem_2])
            #   end
          end

          context "when filtering by related to resources" do
            #   let(:related_to) { 'Decidim::DummyResources::DummyResource'.underscore }
            #   let(:dummy_component) { create(:component, manifest_name: 'dummy', participatory_space: participatory_process) }
            #   let(:dummy_resource) { create :dummy_resource, component: dummy_component }

            it "returns only solutions related to results"
            #     related_problem = create(:problem, :accepted, component: component)
            #     related_problem_2 = create(:problem, :accepted, component: component)
            #     create_list(:problem, 3, component: component)
            #     dummy_resource.link_resources([related_problem], 'included_problems')
            #     related_problem_2.link_resources([dummy_resource], 'included_problems')

            #     expect(subject).to match_array([related_problem, related_problem_2])
            #   end
          end
        end
      end
    end
  end
end
