# frozen_string_literal: true

module Decidim
  module Problems
    ProblemType = GraphQL::ObjectType.define do
      name "Problem"
      description "A problem"

      interfaces [
        -> { Decidim::Core::TraceableInterface },
        -> { Decidim::Core::TimestampsInterface },
      ]

      field :id, !types.ID
      field :title, !Decidim::Core::TranslatedFieldType, "The title of this problem (same as the component name)."
      field :description, Decidim::Core::TranslatedFieldType, "The description of this problem."
      field :challenge, Decidim::Challenges::ChallengeType do
        description "The related Challenge"
        resolve ->(problem, _, _) {
          problem.challenge
        }
      end
      field :sectorial_scope, Decidim::Core::ScopeApiType, "The object's sectorial scope"
      field :technological_scope, Decidim::Core::ScopeApiType, "The object's technological scope"
      field :tags, Decidim::Core::TranslatedFieldType, "The tags of this problem."
      field :state, types.String, "The state for this problem."
      field :start_date, Decidim::Core::DateType do
        description "The start date"
        property :start_date
      end
      field :end_date, Decidim::Core::DateType do
        description "The end date"
        property :end_date
      end
      field :published_at, Decidim::Core::DateTimeType do
        description "The moment at which it was published"
        property :published_at
      end
      field :causes, types.String, "The entities proposing this problem."
      field :groups_affected, types.String, "The entities proposing this problem."
      field :proposing_entities, types.String, "The entities proposing this problem."
      field :collaborating_entities, types.String, "The entities collaborating with this problem."
    end
  end
end
