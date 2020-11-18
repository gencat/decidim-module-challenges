# frozen_string_literal: true

module Decidim
  module Solutions
    # The data store for a Solution in the Decidim::Solutions component.
    class Solution < Challenges::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::ScopableComponent
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      # FIX define possible requirements !
      VALID_REQUIREMENTS = [:technical, :economic, :financial].freeze
      enum requirements: VALID_REQUIREMENTS

      component_manifest_name "solutions"

      belongs_to :challenge, foreign_key: "decidim_challenges_challenge_id", class_name: "Decidim::Challenges::Challenge"
      belongs_to :problem, foreign_key: "decidim_challenges_problem_id", class_name: "Decidim::Problems::Problem"

      scope :published, -> { where.not(published_at: nil) }
      scope :in_technical, -> { where(requirements: VALID_REQUIREMENTS.index(:technical)) }
      scope :in_economic, -> { where(requirements: VALID_REQUIREMENTS.index(:economic)) }
      scope :in_financial, -> { where(requirements: VALID_REQUIREMENTS.index(:financial)) }

      searchable_fields({
                          scope_id: :decidim_scope_id,
                          participatory_space: :itself,
                          A: :title,
                          B: :description,
                          C: "",
                          D: "",
                          datetime: :published_at
                        },
                        index_on_create: ->(solution) { solution.published? },
                        index_on_update: ->(solution) { solution.published? })

      def published?
        published_at.present?
      end
    end
  end
end
