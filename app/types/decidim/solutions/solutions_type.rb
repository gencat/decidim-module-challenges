# frozen_string_literal: true

module Decidim
  module Solutions
    SolutionsType = GraphQL::ObjectType.define do
      interfaces [-> { Decidim::Core::ComponentInterface }]

      name "Solutions"
      description "A solutions component of a participatory space."

      connection :solutions, SolutionType.connection_type do
        resolve ->(component, _args, _ctx) {
                  SolutionsTypeHelper.base_scope(component).includes(:component)
                }
      end

      field(:solution, SolutionType) do
        argument :id, !types.ID

        resolve ->(component, args, _ctx) {
          SolutionsTypeHelper.base_scope(component).find_by(id: args[:id])
        }
      end
    end

    module SolutionsTypeHelper
      def self.base_scope(component)
        Solution.where(component: component).published
      end
    end
  end
end
