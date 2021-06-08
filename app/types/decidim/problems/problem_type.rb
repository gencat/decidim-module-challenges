# frozen_string_literal: true

module Decidim
  module Problems
    class ProblemType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::TraceableInterface
      implements Decidim::Core::TimestampsInterface

      graphql_name "Problem"
      description "A problem"

      field :id, GraphQL::Types::ID, null: false
      field :title, Decidim::Core::TranslatedFieldType, "The title of this problem (same as the component name).", null: false
      field :description, Decidim::Core::TranslatedFieldType, "The description of this problem.", null: true
      field :challenge, Decidim::Challenges::ChallengeType, "The related Challenge", null: true
      field :sectorial_scope, Decidim::Core::ScopeApiType, "The object's sectorial scope", null: true
      field :technological_scope, Decidim::Core::ScopeApiType, "The object's technological scope", null: true
      field :tags, Decidim::Core::TranslatedFieldType, "The tags of this problem.", null: true
      field :state, GraphQL::Types::String, "The state for this problem.", null: true
      field :start_date, Decidim::Core::DateType, "The start date", null: true
      field :end_date, Decidim::Core::DateType, "The end date", null: true
      field :published_at, Decidim::Core::DateTimeType, "The moment at which it was published", null: true
      field :causes, GraphQL::Types::String, "The entities proposing this problem.", null: true
      field :groups_affected, GraphQL::Types::String, "The entities proposing this problem.", null: true
      field :proposing_entities, GraphQL::Types::String, "The entities proposing this problem.", null: true
      field :collaborating_entities, GraphQL::Types::String, "The entities collaborating with this problem.", null: true
    end
  end
end
