# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"

module Decidim
  module Problems
    describe ProblemsType, type: :graphql do
      include_context "with a graphql class type"
      let(:model) { create(:problems_component) }

      it_behaves_like "a component query type"

      describe "problems" do
        let!(:problems) { create_list(:problem, 2, component: model) }
        let!(:other_problems) { create_list(:problem, 2) }

        let(:query) { "{ problems { edges { node { id } } } }" }

        it "returns the published problems" do
          ids = response["problems"]["edges"].map { |edge| edge["node"]["id"] }
          expect(ids).to include(*problems.map(&:id).map(&:to_s))
          expect(ids).not_to include(*other_problems.map(&:id).map(&:to_s))
        end
      end

      describe "problem" do
        let(:query) { "query Problem($id: ID!){ problem(id: $id) { id } }" }
        let(:variables) { { id: problem.id.to_s } }

        context "when the problem belongs to the component" do
          let!(:problem) { create(:problem, component: model) }

          it "finds the problem" do
            expect(response["problem"]["id"]).to eq(problem.id.to_s)
          end
        end

        context "when the problem doesn't belong to the component" do
          let!(:problem) { create(:problem, component: create(:problems_component)) }

          it "returns null" do
            expect(response["problem"]).to be_nil
          end
        end
      end
    end
  end
end
