# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Challenges
    describe ChallengeSearch do
      let(:component) { create(:component, manifest_name: 'proposals') }
      let(:scope1) { create :scope, organization: component.organization }
      let(:scope2) { create :scope, organization: component.organization }
      let(:subscope1) { create :scope, organization: component.organization, parent: scope1 }
      let(:participatory_process) { component.participatory_space }
      let(:user) { create(:user, organization: component.organization) }
      let!(:challenge) { create(:challenge, component: component, scope: scope1) }

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

          expect(subject).to include(challenge)
          expect(subject).not_to include(other_challenge)
        end

        describe 'search_text filter' do
          let(:search_text) { 'dog' }

          it 'returns the challenges containing the search in the title or the body' do
            create_list(:challenge, 3, component: component)
            create(:challenge, title: 'A dog', component: component)
            create(:challenge, body: 'There is a dog in the office', component: component)

            expect(subject.size).to eq(2)
          end
        end

        describe 'state filter' do
          context 'when filtering for default states' do
            it 'returns all except withdrawn proposals' do
              create_list(:proposal, 3, :withdrawn, component: component)
              other_proposals = create_list(:proposal, 3, component: component)
              other_proposals << proposal

              expect(subject.size).to eq(4)
              expect(subject).to match_array(other_proposals)
            end
          end

          context 'when filtering :except_rejected proposals' do
            let(:states) { %w[accepted evaluating not_answered] }

            it 'hides withdrawn and rejected proposals' do
              create(:proposal, :withdrawn, component: component)
              create(:proposal, :rejected, component: component)
              accepted_proposal = create(:proposal, :accepted, component: component)

              expect(subject.size).to eq(2)
              expect(subject).to match_array([accepted_proposal, proposal])
            end
          end

          context 'when filtering accepted proposals' do
            let(:states) { %w[accepted] }

            it 'returns only accepted proposals' do
              accepted_proposals = create_list(:proposal, 3, :accepted, component: component)
              create_list(:proposal, 3, component: component)

              expect(subject.size).to eq(3)
              expect(subject).to match_array(accepted_proposals)
            end
          end

          context 'when filtering rejected proposals' do
            let(:states) { %w[rejected] }

            it 'returns only rejected proposals' do
              create_list(:proposal, 3, component: component)
              rejected_proposals = create_list(:proposal, 3, :rejected, component: component)

              expect(subject.size).to eq(3)
              expect(subject).to match_array(rejected_proposals)
            end
          end

          context 'when filtering withdrawn proposals' do
            let(:states) { %w[withdrawn] }

            it 'returns only withdrawn proposals' do
              create_list(:proposal, 3, component: component)
              withdrawn_proposals = create_list(:proposal, 3, :withdrawn, component: component)

              expect(subject.size).to eq(3)
              expect(subject).to match_array(withdrawn_proposals)
            end
          end
        end

        describe 'scope_id filter' do
          let!(:proposal2) { create(:proposal, component: component, scope: scope2) }
          let!(:proposal3) { create(:proposal, component: component, scope: subscope1) }

          context 'when a parent scope id is being sent' do
            let(:scope_ids) { [scope1.id] }

            it 'filters proposals by scope' do
              expect(subject).to match_array [proposal, proposal3]
            end
          end

          context 'when a subscope id is being sent' do
            let(:scope_ids) { [subscope1.id] }

            it 'filters proposals by scope' do
              expect(subject).to eq [proposal3]
            end
          end

          context 'when multiple ids are sent' do
            let(:scope_ids) { [scope2.id, scope1.id] }

            it 'filters proposals by scope' do
              expect(subject).to match_array [proposal, proposal2, proposal3]
            end
          end

          context 'when `global` is being sent' do
            let!(:resource_without_scope) { create(:proposal, component: component, scope: nil) }
            let(:scope_ids) { ['global'] }

            it 'returns proposals without a scope' do
              expect(subject).to eq [resource_without_scope]
            end
          end

          context 'when `global` and some ids is being sent' do
            let!(:resource_without_scope) { create(:proposal, component: component, scope: nil) }
            let(:scope_ids) { ['global', scope2.id, scope1.id] }

            it 'returns proposals without a scope and with selected scopes' do
              expect(subject).to match_array [resource_without_scope, proposal, proposal2, proposal3]
            end
          end
        end

        describe 'category_id filter' do
          let(:category1) { create :category, participatory_space: participatory_process }
          let(:category2) { create :category, participatory_space: participatory_process }
          let(:child_category) { create :category, participatory_space: participatory_process, parent: category2 }
          let!(:proposal2) { create(:proposal, component: component, category: category1) }
          let!(:proposal3) { create(:proposal, component: component, category: category2) }
          let!(:proposal4) { create(:proposal, component: component, category: child_category) }

          context 'when no category filter is present' do
            it 'includes all proposals' do
              expect(subject).to match_array [proposal, proposal2, proposal3, proposal4]
            end
          end

          context 'when a category is selected' do
            let(:category_ids) { [category2.id] }

            it 'includes only proposals for that category and its children' do
              expect(subject).to match_array [proposal3, proposal4]
            end
          end

          context 'when a subcategory is selected' do
            let(:category_ids) { [child_category.id] }

            it 'includes only proposals for that category' do
              expect(subject).to eq [proposal4]
            end
          end

          context 'when `without` is being sent' do
            let(:category_ids) { ['without'] }

            it 'returns proposals without a category' do
              expect(subject).to eq [proposal]
            end
          end

          context 'when `without` and some category id is being sent' do
            let(:category_ids) { ['without', category1.id] }

            it 'returns proposals without a category and with the selected category' do
              expect(subject).to match_array [proposal, proposal2]
            end
          end
        end

        describe 'related_to filter' do
          context 'when filtering by related to problems' do
            let(:related_to) { 'Decidim::Meetings::Meeting'.underscore }
            let(:meetings_component) { create(:component, manifest_name: 'meetings', participatory_space: participatory_process) }
            let(:meeting) { create :meeting, component: meetings_component }

            it 'returns only proposals related to meetings' do
              related_proposal = create(:proposal, :accepted, component: component)
              related_proposal2 = create(:proposal, :accepted, component: component)
              create_list(:proposal, 3, component: component)
              meeting.link_resources([related_proposal], 'proposals_from_meeting')
              related_proposal2.link_resources([meeting], 'proposals_from_meeting')

              expect(subject).to match_array([related_proposal, related_proposal2])
            end
          end

          context 'when filtering by related to resources' do
            let(:related_to) { 'Decidim::DummyResources::DummyResource'.underscore }
            let(:dummy_component) { create(:component, manifest_name: 'dummy', participatory_space: participatory_process) }
            let(:dummy_resource) { create :dummy_resource, component: dummy_component }

            it 'returns only proposals related to results' do
              related_proposal = create(:proposal, :accepted, component: component)
              related_proposal2 = create(:proposal, :accepted, component: component)
              create_list(:proposal, 3, component: component)
              dummy_resource.link_resources([related_proposal], 'included_proposals')
              related_proposal2.link_resources([dummy_resource], 'included_proposals')

              expect(subject).to match_array([related_proposal, related_proposal2])
            end
          end
        end
      end
    end
  end
end
