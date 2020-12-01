# frozen_string_literal: true

module Decidim
  module Solutions
    # The data store for a Solution in the Decidim::Solutions component.
    class Solution < Decidim::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::ScopableComponent
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      component_manifest_name "solutions"

      belongs_to :problem, foreign_key: "decidim_problems_problem_id", class_name: "Decidim::Problems::Problem"

      scope :published, -> { where.not(published_at: nil) }

      searchable_fields({
                          scope_id: :decidim_scope_id,
                          participatory_space: :itself,
                          A: :title,
                          B: :description,
                          C: "",
                          D: "",
                          datetime: :published_at,
                        },
                        index_on_create: ->(solution) { solution.published? },
                        index_on_update: ->(solution) { solution.published? })

      def published?
        published_at.present?
      end
    end
  end
end
