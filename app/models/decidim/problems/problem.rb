# frozen_string_literal: true

module Decidim
  module Problems
    # The data store for a Problem in the Decidim::Problems component.
    class Problem < Problems::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      VALID_STATES = [:proposal, :execution, :finished].freeze
      enum state: VALID_STATES

      component_manifest_name "problems"

      belongs_to :challenge, foreign_key: "decidim_challenges_challenge_id", class_name: "Decidim::Challenges::Challenge"

      scope :published, -> { where.not(published_at: nil) }
      scope :in_proposal, -> { where(state: VALID_STATES.index(:proposal)) }
      scope :in_execution, -> { where(state: VALID_STATES.index(:execution)) }
      scope :in_finished, -> { where(state: VALID_STATES.index(:finished)) }

      searchable_fields({
                          scope_id: "",
                          participatory_space: :itself,
                          A: :title,
                          B: :description,
                          C: "",
                          D: "",
                          datetime: :published_at,
                        },
                        index_on_create: ->(problem) { problem.published? },
                        index_on_update: ->(problem) { problem.published? })

      def published?
        published_at.present?
      end
    end
  end
end
