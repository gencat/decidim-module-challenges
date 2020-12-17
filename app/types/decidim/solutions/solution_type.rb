# frozen_string_literal: true

module Decidim
  module Solutions
    SolutionType = GraphQL::ObjectType.define do
      name "Solution"
      description "A solution"

      interfaces [
        -> { Decidim::Core::TraceableInterface },
        -> { Decidim::Core::TimestampsInterface },
      ]

      field :id, !types.ID
      field :title, !Decidim::Core::TranslatedFieldType, "The title of this solution (same as the component name)."
      field :description, Decidim::Core::TranslatedFieldType, "The description of this solution."
      field :problem, Decidim::Problems::ProblemType do
        description "The related Problem"
        resolve ->(solution, _, _) {
          solution.problem
        }
      end

      field :tags, Decidim::Core::TranslatedFieldType, "The tags of this solution."
      field :indicators, Decidim::Core::TranslatedFieldType, "The indicators of this solution."
      field :beneficiaries, Decidim::Core::TranslatedFieldType, "The beneficiaries of this solution."
      field :requirements, Decidim::Core::TranslatedFieldType, "The requirements of this solution."
      field :financing_type, Decidim::Core::TranslatedFieldType, "The financing_type of this solution."
      field :objectives, Decidim::Core::TranslatedFieldType, "The objectives of this solution."
      field :published_at, Decidim::Core::DateTimeType do
        description "The moment at which it was published"
        property :published_at
      end
    end
  end
end
