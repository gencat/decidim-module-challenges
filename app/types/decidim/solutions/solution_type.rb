# frozen_string_literal: true

module Decidim
  module Solutions
    SolutionType = GraphQL::ObjectType.define do
      name "Solution"
      description "A solution"

      interfaces [
        -> { Decidim::Core::ScopableInterface },
        -> { Decidim::Core::AttachableInterface },
        -> { Decidim::Core::TraceableInterface },
        -> { Decidim::Core::TimestampsInterface },
      ]

      field :id, !types.ID
      field :title, !Decidim::Core::TranslatedFieldType, "The title of this solution (same as the component name)."
      # field :local_description, Decidim::Core::TranslatedFieldType, "The local description of this solution."
      # field :global_description, Decidim::Core::TranslatedFieldType, "The global description of this solution."
      # field :tags, Decidim::Core::TranslatedFieldType, "The tags of this solution."
      # field :sdg_code, types.String, "The Sustainable Development Goal this solution is associated with."
      # field :state, types.String, "The state for this solution."
      # field :start_date, Decidim::Core::DateType do
      #   description "The start date"
      #   property :start_date
      # end
      # field :end_date, Decidim::Core::DateType do
      #   description "The end date"
      #   property :end_date
      # end
      field :published_at, Decidim::Core::DateTimeType do
        description "The moment at which it was published"
        property :published_at
      end
      # field :coordinating_entities, types.String, "The entities coordinating this solution."
      # field :collaborating_entities, types.String, "The entities collaborating with this solution."
    end
  end
end
