# frozen_string_literal: true

require "spec_helper"
require_relative "../search_scopes_examples"

module Decidim
  module Challenges
    describe ChallengeSearch do
      let(:component) { create(:challenges_component) }
      let(:participatory_process) { component.participatory_space }
      let!(:challenges_list) { create_list(:challenge, 3, component: component) }

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

        it "only includes challenges from the given component" do
          other_challenge = create(:challenge)

          expect(subject).to match_array(challenges_list)
          expect(subject).not_to include(other_challenge)
        end

        describe "search_text filter" do
          let(:search_text) { "dog" }

          it "returns the challenges containing the search in the title or the body" do
            dog_challenge = create(:challenge, title: { I18n.locale => "A dog" }, component: component)

            expect(subject).to include(dog_challenge)
            expect(subject.size).to eq(1)
          end
        end

        describe "state filter" do
          context "when filtering for default states" do
            it "returns all challenges" do
              expect(subject.size).to eq(3)
              expect(subject).to match_array(challenges_list)
            end
          end

          context "when filtering challenges in :proposal state" do
            let(:states) { %w(proposal) }

            it "hides execution and finished proposals" do
              create(:challenge, :finished, component: component)
              proposal_challenge = create(:challenge, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(proposal_challenge)
            end
          end

          context "when filtering challenges in :execution state" do
            let(:states) { %w(execution) }

            it "returns only execution proposals" do
              create(:challenge, :finished, component: component)
              create(:challenge, :proposal, component: component)

              expect(subject.size).to eq(3)
              expect(subject).to match_array(challenges_list)
            end
          end

          context "when filtering challenges in :finished state" do
            let(:states) { %w(finished) }

            it "returns only finished proposals" do
              finished_challenge = create(:challenge, :finished, component: component)
              create(:challenge, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(finished_challenge)
            end
          end
        end

        describe "challenge territorial scopes" do
          include_context "with example scopes"

          let(:resources_list) { challenges_list }
          let!(:resource_without_scope) { create(:challenge, component: component, scope: nil) }
          let!(:resource_1) { create(:challenge, component: component, scope: scope_1) }
          let!(:resource_2) { create(:challenge, component: component, scope: scope_2) }
          let!(:resource_3) { create(:challenge, component: component, scope: subscope_1) }

          context "with sectorial_scope_ids" do
            include_examples "search scope filter", "scope_ids"
          end
        end

        describe "ods filter" do
          context "when none is selected" do
            it "does not apply the filter" do
              expect(subject).to match_array(challenges_list)
            end
          end

          context "when one SDG is selected" do
            let(:sdg_code) { Decidim::Sdgs::Sdg::SDGS.index(:responsible_consumption) }
            let!(:challenge_w_sdg) { create(:challenge, component: component, sdg_code: sdg_code) }
            let(:sdgs_codes) { [sdg_code] }

            it "returns the problems associated to the given SDG" do
              expect(subject.pluck(:id)).to contain_exactly(challenge_w_sdg.id)
            end
          end
        end

        # describe "related_to filter" do
        pending "when filtering by related to problems"
        #   let(:related_to) { 'Decidim::Meetings::Meeting'.underscore }
        #   let(:problems_component) { create(:component, manifest_name: 'problems', participatory_space: participatory_process) }
        #   let(:problem) { create :problem, component: problems_component }

        # it "returns only challenges related to problems"
        #     related_challenge = create(:challenge, :accepted, component: component)
        #     related_challenge_2 = create(:challenge, :accepted, component: component)
        #     create_list(:challenge, 3, component: component)
        #     problem.link_resources([related_challenge], 'challenges_from_problem')
        #     related_challenge_2.link_resources([problem], 'challenges_from_problem')

        #     expect(subject).to match_array([related_challenge, related_challenge_2])
        #   end

        pending "when filtering by related to resources"
        #   let(:related_to) { 'Decidim::DummyResources::DummyResource'.underscore }
        #   let(:dummy_component) { create(:component, manifest_name: 'dummy', participatory_space: participatory_process) }
        #   let(:dummy_resource) { create :dummy_resource, component: dummy_component }

        # it "returns only challenges related to results"
        #     related_challenge = create(:challenge, :accepted, component: component)
        #     related_challenge_2 = create(:challenge, :accepted, component: component)
        #     create_list(:challenge, 3, component: component)
        #     dummy_resource.link_resources([related_challenge], 'included_challenges')
        #     related_challenge_2.link_resources([dummy_resource], 'included_challenges')

        #     expect(subject).to match_array([related_challenge, related_challenge_2])
        #   end
        # end
      end
    end
  end
end
