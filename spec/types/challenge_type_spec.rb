# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"
require "decidim/core/test/shared_examples/scopable_interface_examples"

module Decidim
  module Challenges
    describe ChallengeType, type: :graphql do
      include_context "with a graphql type"

      let(:model) { create(:challenge) }

      include_examples "scopable interface"

      describe "id" do
        let(:query) { "{ id }" }

        it "returns all the required fields" do
          expect(response).to include("id" => model.id.to_s)
        end
      end

      describe "title" do
        let(:query) { '{ title { translation(locale: "en")}}' }

        it "returns all the required fields" do
          expect(response["title"]["translation"]).to eq(model.title["en"])
        end
      end

      describe "local_description" do
        let(:query) { '{ local_description { translation(locale: "en")}}' }

        it "returns all the required fields" do
          expect(response["local_description"]["translation"]).to eq(model.local_description["en"])
        end
      end

      describe "global_description" do
        let(:query) { '{ global_description { translation(locale: "en")}}' }

        it "returns all the required fields" do
          expect(response["global_description"]["translation"]).to eq(model.global_description["en"])
        end
      end

      describe "tags" do
        let(:query) { '{ tags { translation(locale: "en")}}' }

        it "returns all the required fields" do
          expect(response["tags"]["translation"]).to eq(model.tags["en"])
        end
      end

      describe "sdg_code" do
        let(:query) { '{ sdg_code }' }

        it "returns all the required fields" do
          expect(response["sdg_code"]).to eq(model.sdg_code)
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
