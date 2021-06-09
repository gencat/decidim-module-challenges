# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"
require "decidim/core/test/shared_examples/scopable_interface_examples"

module Decidim
  module Challenges
    describe ChallengeType, type: :graphql do
      include_context "with a graphql class type"

      let(:model) { create(:challenge) }

      include_examples "scopable interface"

      describe "id" do
        let(:query) { "{ id }" }

        it "returns the required value" do
          expect(response).to include("id" => model.id.to_s)
        end
      end

      describe "title" do
        let(:query) { '{ title { translation(locale: "en")}}' }

        it "returns the required value" do
          expect(response["title"]["translation"]).to eq(model.title["en"])
        end
      end

      describe "local description" do
        let(:query) { '{ localDescription { translation(locale: "en")}}' }

        it "returns the required value" do
          expect(response["localDescription"]["translation"]).to eq(model.local_description["en"])
        end
      end

      describe "global description" do
        let(:query) { '{ globalDescription { translation(locale: "en")}}' }

        it "returns the required value" do
          expect(response["globalDescription"]["translation"]).to eq(model.global_description["en"])
        end
      end

      describe "tags" do
        let(:query) { '{ tags { translation(locale: "en")} }' }

        it "returns the required value" do
          expect(response["tags"]["translation"]).to eq(model.tags["en"])
        end
      end

      describe "sdgcode" do
        let(:query) { "{ sdgCode }" }

        it "returns the required value" do
          expect(response["sdgCode"]).to eq(model.sdg_code)
        end
      end

      describe "state" do
        let(:query) { "{ state }" }

        it "returns the required value" do
          expect(response["state"]).to eq(model.state)
        end
      end

      describe "dates and times" do
        let(:query) { <<~EOQUERY }
          {
            startDate
            endDate
            publishedAt
          }
        EOQUERY

        it "returns the required values" do
          expect(response["startDate"]).to eq(model.start_date.to_date.iso8601)
          expect(response["endDate"]).to eq(model.end_date.to_date.iso8601)
          expect(response["publishedAt"]).to eq(model.published_at.to_time.iso8601)
        end
      end

      describe "entities" do
        let(:query) { <<~EOQUERY }
          {
            coordinatingEntities
            collaboratingEntities
          }
        EOQUERY

        it "returns the required values" do
          expect(response["coordinatingEntities"]).to eq(model.coordinating_entities)
          expect(response["collaboratingEntities"]).to eq(model.collaborating_entities)
        end
      end

      describe "createdAt" do
        let(:query) { "{ createdAt }" }

        it "returns when the challenge was created" do
          expect(response["createdAt"]).to eq(model.created_at.to_time.iso8601)
        end
      end

      describe "updatedAt" do
        let(:query) { "{ updatedAt }" }

        it "returns when the challenge was updated" do
          expect(response["updatedAt"]).to eq(model.updated_at.to_time.iso8601)
        end
      end
    end
  end
end
