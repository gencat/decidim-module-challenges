# frozen_string_literal: true

module Decidim
  module Challenges
    class ChallengeType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::ScopableInterface
      implements Decidim::Core::AttachableInterface
      implements Decidim::Core::TraceableInterface
      implements Decidim::Core::TimestampsInterface

      graphql_name "Challenge"
      description "A challenge"

      field :id, GraphQL::Types::ID, null: false
      field :title, Decidim::Core::TranslatedFieldType, "The title of this challenge (same as the component name).", null: false
      field :local_description, Decidim::Core::TranslatedFieldType, "The local description of this challenge.", null: true
      field :global_description, Decidim::Core::TranslatedFieldType, "The global description of this challenge.", null: true
      field :tags, Decidim::Core::TranslatedFieldType, "The tags of this challenge.", null: true
      field :sdg_code, GraphQL::Types::String, "The Sustainable Development Goal this challenge is associated with.", null: true
      field :state, GraphQL::Types::String, "The state for this challenge.", null: true
      field :start_date, Decidim::Core::DateType, "The start date", null: true
      field :end_date, Decidim::Core::DateType, "The end date", null: true
      field :published_at, Decidim::Core::DateTimeType, "The moment at which it was published", null: true
      field :coordinating_entities, GraphQL::Types::String, "The entities coordinating this challenge.", null: true
      field :collaborating_entities, GraphQL::Types::String, "The entities collaborating with this challenge.", null: true
    end
  end
end
