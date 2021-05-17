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

      describe "local_description" do
        let(:query) { '{ local_description { translation(locale: "en")}}' }

        it "returns the required value" do
          expect(response["local_description"]["translation"]).to eq(model.local_description["en"])
        end
      end

      describe "global_description" do
        let(:query) { '{ global_description { translation(locale: "en")}}' }

        it "returns the required value" do
          expect(response["global_description"]["translation"]).to eq(model.global_description["en"])
        end
      end

      describe "tags" do
        let(:query) { '{ tags { translation(locale: "en")} }' }

        it "returns the required value" do
          expect(response["tags"]["translation"]).to eq(model.tags["en"])
        end
      end

      describe "sdg_code" do
        let(:query) { "{ sdg_code }" }

        it "returns the required value" do
          expect(response["sdg_code"]).to eq(model.sdg_code)
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
            start_date
            end_date
            published_at
          }
        EOQUERY

        it "returns the required values" do
          expect(response["start_date"]).to eq(model.start_date.to_date.iso8601)
          expect(response["end_date"]).to eq(model.end_date.to_date.iso8601)
          expect(response["published_at"]).to eq(model.published_at.to_time.iso8601)
        end
      end

      describe "entities" do
        let(:query) { <<~EOQUERY }
          {
            coordinating_entities
            collaborating_entities
          }
        EOQUERY

        it "returns the required values" do
          expect(response["coordinating_entities"]).to eq(model.coordinating_entities)
          expect(response["collaborating_entities"]).to eq(model.collaborating_entities)
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
