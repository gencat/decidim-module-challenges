# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

module Decidim
  module Solutions
    describe SolutionType, type: :graphql do
      include_context "with a graphql class type"

      let(:model) { create(:solution) }

      describe "query" do
        let(:query) { <<~EOQUERY }
          {
            id
            title { translation(locale: "en") }
            description { translation(locale: "en") }
            problem { id }
            tags { translation(locale: "en")}
            indicators { translation(locale: "en")}
            beneficiaries { translation(locale: "en")}
            requirements { translation(locale: "en")}
            financingType { translation(locale: "en")}
            objectives { translation(locale: "en")}
            publishedAt
            createdAt
            updatedAt
          }
        EOQUERY

        it "returns the required values" do
          expect(response["id"]).to eq(model.id.to_s)
          expect(response["title"]["translation"]).to eq(model.title["en"])
          expect(response["description"]["translation"]).to eq(model.description["en"])
          expect(response["problem"]["id"]).to eq(model.problem.id.to_s)
          expect(response["tags"]["translation"]).to eq(model.tags["en"])
          expect(response["indicators"]["translation"]).to eq(model.indicators["en"])
          expect(response["beneficiaries"]["translation"]).to eq(model.beneficiaries["en"])
          expect(response["requirements"]["translation"]).to eq(model.requirements["en"])
          expect(response["financingType"]["translation"]).to eq(model.financing_type["en"])
          expect(response["objectives"]["translation"]).to eq(model.objectives["en"])
          expect(response["publishedAt"]).to eq(model.published_at.to_time.iso8601)
          expect(response["createdAt"]).to eq(model.created_at.to_time.iso8601)
          expect(response["updatedAt"]).to eq(model.updated_at.to_time.iso8601)
        end
      end
    end
  end
end
