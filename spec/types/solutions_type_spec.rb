# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"

module Decidim
  module Solutions
    describe SolutionsType, type: :graphql do
      include_context "with a graphql type"
      let(:model) { create(:solutions_component) }

      it_behaves_like "a component query type"

      describe "solutions" do
        let!(:solutions) { create_list(:solution, 2, component: model) }
        let!(:other_solutions) { create_list(:solution, 2) }

        let(:query) { "{ solutions { edges { node { id } } } }" }

        it "returns the published solutions" do
          ids = response["solutions"]["edges"].map { |edge| edge["node"]["id"] }
          expect(ids).to include(*solutions.map(&:id).map(&:to_s))
          expect(ids).not_to include(*other_solutions.map(&:id).map(&:to_s))
        end
      end

      describe "solution" do
        let(:query) { "query Solution($id: ID!){ solution(id: $id) { id } }" }
        let(:variables) { { id: solution.id.to_s } }

        context "when the solution belongs to the component" do
          let!(:solution) { create(:solution, component: model) }

          it "finds the solution" do
            expect(response["solution"]["id"]).to eq(solution.id.to_s)
          end
        end

        context "when the solution doesn't belong to the component" do
          let!(:solution) { create(:solution, component: create(:solutions_component)) }

          it "returns null" do
            expect(response["solution"]).to be_nil
          end
        end
      end
    end
  end
end
