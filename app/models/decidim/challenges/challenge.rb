# frozen_string_literal: true

module Decidim
  module Challenges
    # The data store for a Challenge in the Decidim::Challenges component.
    class Challenge < Decidim::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::ScopableComponent
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      VALID_STATES = [:proposal, :execution, :finished].freeze
      enum state: VALID_STATES

      has_many :problems,
               class_name: "Decidim::Problems::Problem",
               foreign_key: "decidim_challenges_challenge_id", dependent: :restrict_with_exception

      component_manifest_name "challenges"

      scope :published, -> { where.not(published_at: nil) }
      scope :in_proposal, -> { where(state: VALID_STATES.index(:proposal)) }
      scope :in_execution, -> { where(state: VALID_STATES.index(:execution)) }
      scope :in_finished, -> { where(state: VALID_STATES.index(:finished)) }

      searchable_fields({
                          scope_id: :decidim_scope_id,
                          participatory_space: :itself,
                          A: :title,
                          B: :local_description,
                          C: :global_description,
                          D: "",
                          datetime: :published_at,
                        },
                        index_on_create: ->(challenge) { challenge.published? },
                        index_on_update: ->(challenge) { challenge.published? })

      def published?
        published_at.present?
      end
    end
  end
end
