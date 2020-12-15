# frozen_string_literal: true

module Decidim
  module Challenges
    ChallengesType = GraphQL::ObjectType.define do
      interfaces [-> { Decidim::Core::ComponentInterface }]

      name "Challenges"
      description "A challenges component of a participatory space."

      connection :challenges, ChallengeType.connection_type do
        resolve ->(component, _args, _ctx) {
                  ChallengesTypeHelper.base_scope(component).includes(:component)
                }
      end

      field(:challenge, ChallengeType) do
        argument :id, !types.ID

        resolve ->(component, args, _ctx) {
          ChallengesTypeHelper.base_scope(component).find_by(id: args[:id])
        }
      end
    end

    module ChallengesTypeHelper
      def self.base_scope(component)
        Challenge.where(component: component).published
      end
    end
  end
end
