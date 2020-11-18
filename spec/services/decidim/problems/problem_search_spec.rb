# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Problems
    describe ProblemSearch do
      let!(:challenge) { create(:challenge) }
      let(:component) { create(:component, organization: challenge.component.organization, manifest_name: "problems") }
      let(:participatory_process) { component.participatory_space }
      let!(:problems_list) { create_list(:problem, 3, component: component, challenge: challenge) }

      describe "results" do
        subject do
          described_class.new(
            component: component,
            search_text: search_text,
            state: states,
            related_to: related_to,
            scope_id: scope_ids,
            category_id: category_ids,
            sdgs_ids: sdgs_ids
          ).results
        end

        let(:search_text) { nil }
        let(:related_to) { nil }
        let(:states) { nil }
        let(:scope_ids) { nil }
        let(:category_ids) { nil }
        let(:sdgs_ids) { nil }

        it "only includes problems from the given component" do
          other_problem = create(:problem)

          expect(subject).to match_array(problems_list)
          expect(subject).not_to include(other_problem)
        end

        describe "search_text filter" do
          let(:search_text) { "dog" }

          it "returns the problems containing the search in the title or the body" do
            dog_problem = create(:problem, title: { I18n.locale => "A dog" }, component: component)

            expect(subject).to include(dog_problem)
            expect(subject.size).to eq(1)
          end
        end

        describe "state filter" do
          context "when filtering for default states" do
            it "returns all problems" do
              expect(subject.size).to eq(3)
              expect(subject).to match_array(problems_list)
            end
          end

          context "when filtering problems in :proposal state" do
            let(:states) { %w(proposal) }

            it "hides execution and finished proposals" do
              create(:problem, :finished, component: component)
              proposal_problem = create(:problem, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(proposal_problem)
            end
          end

          context "when filtering problems in :execution state" do
            let(:states) { %w(execution) }

            it "returns only execution proposals" do
              create(:problem, :finished, component: component, challenge: challenge)
              create(:problem, :proposal, component: component, challenge: challenge)

              expect(subject.size).to eq(3)
              expect(subject).to match_array(problems_list)
            end
          end

          context "when filtering problems in :finished state" do
            let(:states) { %w(finished) }

            it "returns only finished proposals" do
              finished_problem = create(:problem, :finished, component: component)
              create(:problem, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(finished_problem)
            end
          end
        end

        describe "scope_id filter" do
          let(:scope_1) { create :scope, organization: component.organization }
          let(:scope_2) { create :scope, organization: component.organization }
          let(:subscope_1) { create :scope, organization: component.organization, parent: scope_1 }
          let!(:problem_1) { create(:problem, component: component, scope: scope_1) }
          let!(:problem_2) { create(:problem, component: component, scope: scope_2) }
          let!(:problem_3) { create(:problem, component: component, scope: subscope_1) }

          context "when a parent scope id is being sent" do
            let(:scope_ids) { [scope_1.id] }

            it "filters problems by scope" do
              expect(subject).to match_array [problem_1, problem_3]
            end
          end

          context "when a subscope id is being sent" do
            let(:scope_ids) { [subscope_1.id] }

            it "filters problems by scope" do
              expect(subject).to eq [problem_3]
            end
          end

          context "when multiple ids are sent" do
            let(:scope_ids) { [scope_2.id, scope_1.id] }

            it "filters problems by scope" do
              expect(subject).to match_array [problem_1, problem_2, problem_3]
            end
          end

          context "when `global` is being sent" do
            let!(:resource_without_scope) { create(:problem, component: component, scope: nil) }
            let(:scope_ids) { ["global"] }

            it "returns problems without a scope" do
              expect(subject.pluck(:id).sort).to eq(problems_list.pluck(:id) + [resource_without_scope.id])
            end
          end

          context "when `global` and some ids is being sent" do
            let!(:resource_without_scope) { create(:problem, component: component, scope: nil) }
            let(:scope_ids) { ["global", scope_2.id, scope_1.id] }

            it "returns problems without a scope and with selected scopes" do
              expect(subject.pluck(:id)).to match_array(problems_list.pluck(:id) + [resource_without_scope.id, problem_1.id, problem_2.id, problem_3.id])
            end
          end
        end

        describe "SDGs filter" do
          context "when none is selected" do
            it "does not apply the filter" do
              expect(subject).to match_array(problems_list)
            end
          end

          context "when one SDG is selected" do
            let(:sdg_id) { Decidim::Sdgs::Sdg::SDGS.index(:zero_hunger) }
            let!(:problem_w_sdg) { create(:problem, component: component, challenge: challenge, sdg_id: sdg_id) }
            let(:sdgs_ids) { [sdg_id] }

            it "returns the problems associated to the given SDG" do
              expect(subject.pluck(:id)).to match_array([problem_w_sdg.id])
            end
          end
        end

        describe "related_to filter" do
          context "when filtering by related to problems" do
            #   let(:related_to) { 'Decidim::Meetings::Meeting'.underscore }
            #   let(:problems_component) { create(:component, manifest_name: 'problems', participatory_space: participatory_process) }
            #   let(:problem) { create :problem, component: problems_component }

            it "returns only problems related to problems"
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

            it "returns only problems related to results"
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
