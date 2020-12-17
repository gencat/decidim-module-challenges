# frozen_string_literal: true

module Decidim
  module Problems
    ProblemsType = GraphQL::ObjectType.define do
      interfaces [-> { Decidim::Core::ComponentInterface }]

      name "Problems"
      description "A problems component of a participatory space."

      connection :problems, ProblemType.connection_type do
        resolve ->(component, _args, _ctx) {
                  ProblemsTypeHelper.base_scope(component).includes(:component)
                }
      end

      field(:problem, ProblemType) do
        argument :id, !types.ID

        resolve ->(component, args, _ctx) {
          ProblemsTypeHelper.base_scope(component).find_by(id: args[:id])
        }
      end
    end

    module ProblemsTypeHelper
      def self.base_scope(component)
        Problem.where(component: component).published
      end
    end
  end
end
