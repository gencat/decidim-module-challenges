# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

module Decidim
  module Problems
    describe ProblemType, type: :graphql do
      include_context "with a graphql class type"

      let(:model) { create(:problem) }
      let(:sectorial_scope) { create(:scope, organization: model.participatory_space.organization) }
      let(:technological_scope) { create(:scope, organization: model.participatory_space.organization) }

      before do
        model.update(sectorial_scope: sectorial_scope, technological_scope: technological_scope)
      end

      describe "query" do
        let(:query) { <<~EOQUERY }
          {
            id
            title { translation(locale: "en") }
            description { translation(locale: "en") }
            challenge { id }
            sectorialScope { id name { translation(locale: "en") } }
            technologicalScope { id name { translation(locale: "en") } }
            tags { translation(locale: "en")}
            causes
            groupsAffected
            state
            startDate
            endDate
            publishedAt
            proposingEntities
            collaboratingEntities
            createdAt
            updatedAt
          }
        EOQUERY

        it "returns the required values" do
          expect(response["id"]).to eq(model.id.to_s)
          expect(response["title"]["translation"]).to eq(model.title["en"])
          expect(response["description"]["translation"]).to eq(model.description["en"])
          expect(response["challenge"]["id"]).to eq(model.challenge.id.to_s)
          expect(response["sectorialScope"]["id"]).to eq(model.sectorial_scope.id.to_s)
          expect(response["technologicalScope"]["id"]).to eq(model.technological_scope.id.to_s)
          expect(response["tags"]["translation"]).to eq(model.tags["en"])
          expect(response["state"]).to eq(model.state)
          expect(response["startDate"]).to eq(model.start_date.to_date.iso8601)
          expect(response["endDate"]).to eq(model.end_date.to_date.iso8601)
          expect(response["publishedAt"]).to eq(model.published_at.to_time.iso8601)
          expect(response["proposingEntities"]).to eq(model.proposing_entities)
          expect(response["collaboratingEntities"]).to eq(model.collaborating_entities)
          expect(response["createdAt"]).to eq(model.created_at.to_time.iso8601)
          expect(response["updatedAt"]).to eq(model.updated_at.to_time.iso8601)
        end
      end
    end
  end
end
