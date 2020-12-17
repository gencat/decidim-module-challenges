# frozen_string_literal: true

module Decidim
  module Challenges
    ChallengeType = GraphQL::ObjectType.define do
      name "Challenge"
      description "A challenge"

      interfaces [
        -> { Decidim::Core::CoauthorableInterface },
        -> { Decidim::Core::ScopableInterface },
        -> { Decidim::Core::AttachableInterface },
        -> { Decidim::Core::TraceableInterface },
        -> { Decidim::Core::TimestampsInterface }
      ]

      field :id, !types.ID
      field :title, !Decidim::Core::TranslatedFieldType, "The title of this challenge (same as the component name)."
      field :local_description, Decidim::Core::TranslatedFieldType, "The local description of this challenge."
      field :global_description, Decidim::Core::TranslatedFieldType, "The global description of this challenge."
      field :tags, Decidim::Core::TranslatedFieldType, "The tags of this challenge."
      field :sdg_code, types.String, "The Sustainable Development Goal this challenge is associated with."
      field :state, types.Int, "The state for this challenge, where the returned values is the index for #{Decidim::Challenges::Challenge::VALID_STATES}."
      field :start_date, Decidim::Core::DateType do
        description "The start date"
        property :start_date
      end
      field :end_date, Decidim::Core::DateType do
        description "The start date"
        property :end_date
      end
      field :published_at, Decidim::Core::DateTimeType do
        description "The start date"
        property :published_at
      end
      field :coordinating_entities, types.String, "The entities coordinating this challenge."
      field :collaborating_entities, types.String, "The entities collaborating with this challenge."
    end
  end
end
