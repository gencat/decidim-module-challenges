# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Solutions
    describe SolutionSearch do
      let!(:challenge) { create(:challenge) }
      let(:component) { create(:component, organization: challenge.component.organization, manifest_name: "solutions") }
      let(:participatory_process) { component.participatory_space }
      let!(:solutions_list) { create_list(:solution, 3, component: component, challenge: challenge) }

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
          other_solution = create(:solution)

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

        describe "state filter" do
          context "when filtering for default states" do
            it "returns all solutions" do
              expect(subject.size).to eq(3)
              expect(subject).to match_array(solutions_list)
            end
          end

          context "when filtering solutions in :proposal state" do
            let(:states) { %w(proposal) }

            it "hides execution and finished proposals" do
              create(:solution, :finished, component: component)
              proposal_solution = create(:solution, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(proposal_solution)
            end
          end

          context "when filtering solutions in :execution state" do
            let(:states) { %w(execution) }

            it "returns only execution proposals" do
              create(:solution, :finished, component: component, challenge: challenge)
              create(:solution, :proposal, component: component, challenge: challenge)

              expect(subject.size).to eq(3)
              expect(subject).to match_array(solutions_list)
            end
          end

          context "when filtering solutions in :finished state" do
            let(:states) { %w(finished) }

            it "returns only finished proposals" do
              finished_solution = create(:solution, :finished, component: component)
              create(:solution, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(finished_solution)
            end
          end
        end

        describe "scope_id filter" do
          let(:scope_1) { create :scope, organization: component.organization }
          let(:scope_2) { create :scope, organization: component.organization }
          let(:subscope_1) { create :scope, organization: component.organization, parent: scope_1 }
          let!(:solution_1) { create(:solution, component: component, scope: scope_1) }
          let!(:solution_2) { create(:solution, component: component, scope: scope_2) }
          let!(:solution_3) { create(:solution, component: component, scope: subscope_1) }

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
            let!(:resource_without_scope) { create(:solution, component: component, scope: nil) }
            let(:scope_ids) { ["global"] }

            it "returns solutions without a scope" do
              expect(subject.pluck(:id).sort).to eq(solutions_list.pluck(:id) + [resource_without_scope.id])
            end
          end

          context "when `global` and some ids is being sent" do
            let!(:resource_without_scope) { create(:solution, component: component, scope: nil) }
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
            let(:sdgs_code) { Decidim::Sdgs::Sdg::SDGS.index(:zero_hunger) }
            let!(:solution_w_sdg) { create(:solution, component: component, challenge: challenge) }
            let(:sdgs_codes) { [sdgs_code] }

            before do
              challenge.update!(sdgs_code: sdgs_code)
            end

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
