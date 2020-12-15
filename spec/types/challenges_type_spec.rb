# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"

module Decidim
  module Challenges
    describe ChallengesType, type: :graphql do
      include_context "with a graphql type"
      let(:model) { create(:challenges_component) }

      it_behaves_like "a component query type"

      describe "challenges" do
        let!(:challenges) { create_list(:challenge, 2, component: model) }
        let!(:other_challenges) { create_list(:challenge, 2) }

        let(:query) { "{ challenges { edges { node { id } } } }" }

        it "returns the published challenges" do
          ids = response["challenges"]["edges"].map { |edge| edge["node"]["id"] }
          expect(ids).to include(*challenges.map(&:id).map(&:to_s))
          expect(ids).not_to include(*other_challenges.map(&:id).map(&:to_s))
        end
      end

      describe "challenge" do
        let(:query) { "query Challenge($id: ID!){ challenge(id: $id) { id } }" }
        let(:variables) { { id: challenge.id.to_s } }

        context "when the challenge belongs to the component" do
          let!(:challenge) { create(:challenge, component: model) }

          it "finds the challenge" do
            expect(response["challenge"]["id"]).to eq(challenge.id.to_s)
          end
        end

        context "when the challenge doesn't belong to the component" do
          let!(:challenge) { create(:challenge, component: create(:challenges_component)) }

          it "returns null" do
            expect(response["challenge"]).to be_nil
          end
        end
      end
    end
  end
end
