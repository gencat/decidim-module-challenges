# frozen_string_literal: true

module Decidim
  module Problems
    class ProblemsType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::ComponentInterface

      graphql_name "Problems"
      description "A problems component of a participatory space."

      field :problems, ProblemType.connection_type, null: true, connection: true

      def problems
        ProblemsTypeHelper.base_scope(object).includes(:component)
      end

      field(:problem, ProblemType, null: true) do
        argument :id, GraphQL::Types::ID, required: true
      end

      def problem(**args)
        ProblemsTypeHelper.base_scope(object).find_by(id: args[:id])
      end
    end

    module ProblemsTypeHelper
      def self.base_scope(component)
        Problem.where(component: component).published
      end
    end
  end
end
