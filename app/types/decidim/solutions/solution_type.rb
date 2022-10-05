# frozen_string_literal: true

module Decidim
  module Solutions
    class SolutionType < Decidim::Api::Types::BaseObject
      implements Decidim::Core::TraceableInterface
      implements Decidim::Core::TimestampsInterface

      graphql_name "Solution"
      description "A solution"

      field :id, GraphQL::Types::ID, null: false
      field :title, Decidim::Core::TranslatedFieldType, "The title of this solution (same as the component name).", null: false
      field :description, Decidim::Core::TranslatedFieldType, "The description of this solution.", null: true
      field :problem, Decidim::Problems::ProblemType, "The related Problem", null: true
      field :tags, Decidim::Core::TranslatedFieldType, "The tags of this solution.", null: true
      field :indicators, Decidim::Core::TranslatedFieldType, "The indicators of this solution.", null: true
      field :beneficiaries, Decidim::Core::TranslatedFieldType, "The beneficiaries of this solution.", null: true
      field :requirements, Decidim::Core::TranslatedFieldType, "The requirements of this solution.", null: true
      field :financing_type, Decidim::Core::TranslatedFieldType, "The financing_type of this solution.", null: true
      field :objectives, Decidim::Core::TranslatedFieldType, "The objectives of this solution.", null: true
      field :published_at, Decidim::Core::DateTimeType, "The moment at which it was published", null: true
    end
  end
end
