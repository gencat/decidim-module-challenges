# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Challenges
    describe ChallengeSearch do
      let(:component) { create(:component, manifest_name: 'challenges') }
      let(:participatory_process) { component.participatory_space }
      let!(:challenges_list) { create_list(:challenge, 3, component: component) }

      describe 'results' do
        subject do
          described_class.new(
            component: component,
            search_text: search_text,
            state: states,
            related_to: related_to,
            scope_id: scope_ids,
            category_id: category_ids
          ).results
        end

        let(:search_text) { nil }
        let(:related_to) { nil }
        let(:states) { nil }
        let(:scope_ids) { nil }
        let(:category_ids) { nil }

        it 'only includes challenges from the given component' do
          other_challenge = create(:challenge)

          expect(subject).to match_array(challenges_list)
          expect(subject).not_to include(other_challenge)
        end

        describe 'search_text filter' do
          let(:search_text) { 'dog' }

          it 'returns the challenges containing the search in the title or the body' do
            dog_challenge = create(:challenge, title: { I18n.locale => 'A dog' }, component: component)

            expect(subject).to include(dog_challenge)
            expect(subject.size).to eq(1)
          end
        end

        describe 'state filter' do
          context 'when filtering for default states' do
            it 'returns all challenges' do
              expect(subject.size).to eq(3)
              expect(subject).to match_array(challenges_list)
            end
          end

          context 'when filtering challenges in :proposal state' do
            let(:states) { %w[proposal] }

            it 'hides executing and finished proposals' do
              create(:challenge, :finished, component: component)
              proposal_challenge = create(:challenge, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(proposal_challenge)
            end
          end

          context 'when filtering challenges in :executing state' do
            let(:states) { %w[executing] }

            it 'returns only executing proposals' do
              create(:challenge, :finished, component: component)
              create(:challenge, :proposal, component: component)

              expect(subject.size).to eq(3)
              expect(subject).to match_array(challenges_list)
            end
          end

          context 'when filtering challenges in :finished state' do
            let(:states) { %w[finished] }

            it 'returns only finished proposals' do
              finished_challenge = create(:challenge, :finished, component: component)
              create(:challenge, :proposal, component: component)

              expect(subject.size).to eq(1)
              expect(subject).to include(finished_challenge)
            end
          end
        end

        describe 'scope_id filter' do
          let(:scope_1) { create :scope, organization: component.organization }
          let(:scope_2) { create :scope, organization: component.organization }
          let(:subscope_1) { create :scope, organization: component.organization, parent: scope_1 }
          let!(:challenge_1) { create(:challenge, component: component, scope: scope_1) }
          let!(:challenge_2) { create(:challenge, component: component, scope: scope_2) }
          let!(:challenge_3) { create(:challenge, component: component, scope: subscope_1) }

          context 'when a parent scope id is being sent' do
            let(:scope_ids) { [scope_1.id] }

            it 'filters challenges by scope' do
              expect(subject).to match_array [challenge_1, challenge_3]
            end
          end

          context 'when a subscope id is being sent' do
            let(:scope_ids) { [subscope_1.id] }

            it 'filters challenges by scope' do
              expect(subject).to eq [challenge_3]
            end
          end

          context 'when multiple ids are sent' do
            let(:scope_ids) { [scope_2.id, scope_1.id] }

            it 'filters challenges by scope' do
              expect(subject).to match_array [challenge_1, challenge_2, challenge_3]
            end
          end

          context 'when `global` is being sent' do
            let!(:resource_without_scope) { create(:challenge, component: component, scope: nil) }
            let(:scope_ids) { ['global'] }

            it 'returns challenges without a scope' do
              expect(subject).to eq [resource_without_scope]
            end
          end

          context 'when `global` and some ids is being sent' do
            let!(:resource_without_scope) { create(:challenge, component: component, scope: nil) }
            let(:scope_ids) { ['global', scope_2.id, scope_1.id] }

            it 'returns challenges without a scope and with selected scopes' do
              expect(subject).to match_array [resource_without_scope, challenge_1, challenge_2, challenge_3]
            end
          end
        end

        describe 'related_to filter' do
          context 'when filtering by related to problems' do
            #   let(:related_to) { 'Decidim::Meetings::Meeting'.underscore }
            #   let(:problems_component) { create(:component, manifest_name: 'problems', participatory_space: participatory_process) }
            #   let(:problem) { create :problem, component: problems_component }

            it 'returns only challenges related to problems'
            #     related_challenge = create(:challenge, :accepted, component: component)
            #     related_challenge_2 = create(:challenge, :accepted, component: component)
            #     create_list(:challenge, 3, component: component)
            #     problem.link_resources([related_challenge], 'challenges_from_problem')
            #     related_challenge_2.link_resources([problem], 'challenges_from_problem')

            #     expect(subject).to match_array([related_challenge, related_challenge_2])
            #   end
          end

          context 'when filtering by related to resources' do
            #   let(:related_to) { 'Decidim::DummyResources::DummyResource'.underscore }
            #   let(:dummy_component) { create(:component, manifest_name: 'dummy', participatory_space: participatory_process) }
            #   let(:dummy_resource) { create :dummy_resource, component: dummy_component }

            it 'returns only challenges related to results'
            #     related_challenge = create(:challenge, :accepted, component: component)
            #     related_challenge_2 = create(:challenge, :accepted, component: component)
            #     create_list(:challenge, 3, component: component)
            #     dummy_resource.link_resources([related_challenge], 'included_challenges')
            #     related_challenge_2.link_resources([dummy_resource], 'included_challenges')

            #     expect(subject).to match_array([related_challenge, related_challenge_2])
            #   end
          end
        end
      end
    end
  end
end
