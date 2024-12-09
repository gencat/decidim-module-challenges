# frozen_string_literal: true

module Decidim
  module Solutions
    class SolutionsType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::ComponentInterface

      graphql_name "Solutions"
      description "A solutions component of a participatory space."

      field :solutions, SolutionType.connection_type, null: true, connection: true

      def solutions
        SolutionsTypeHelper.base_scope(object).includes(:component)
      end

      field(:solution, SolutionType, null: true) do
        argument :id, GraphQL::Types::ID, required: true
      end

      def solution(**args)
        SolutionsTypeHelper.base_scope(object).find_by(id: args[:id])
      end
    end

    module SolutionsTypeHelper
      def self.base_scope(component)
        Solution.where(component:).published
      end
    end
  end
end
