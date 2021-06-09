# frozen_string_literal: true

module Decidim
  module Challenges
    class ChallengesType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::ComponentInterface

      graphql_name "Challenges"
      description "A challenges component of a participatory space."

      field :challenges, ChallengeType.connection_type, null: true, connection: true

      def challenges
        ChallengesTypeHelper.base_scope(object).includes(:component)
      end

      field(:challenge, ChallengeType, null: true) do
        argument :id, GraphQL::Types::ID, required: true
      end

      def challenge(**args)
        ChallengesTypeHelper.base_scope(object).find_by(id: args[:id])
      end
    end

    module ChallengesTypeHelper
      def self.base_scope(component)
        Challenge.where(component: component).published
      end
    end
  end
end
