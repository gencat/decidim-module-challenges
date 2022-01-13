# frozen_string_literal: true

module Decidim
  module Problems
    # The data store for a Problem in the Decidim::Problems component.
    class Problem < Decidim::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes
      include Decidim::Randomable

      VALID_STATES = [:proposal, :execution, :finished].freeze
      enum state: VALID_STATES

      component_manifest_name "problems"

      belongs_to :challenge, foreign_key: "decidim_challenges_challenge_id", class_name: "Decidim::Challenges::Challenge"

      belongs_to :sectorial_scope,
                 foreign_key: "decidim_sectorial_scope_id",
                 class_name: "Decidim::Scope",
                 optional: true
      belongs_to :technological_scope,
                 foreign_key: "decidim_technological_scope_id",
                 class_name: "Decidim::Scope",
                 optional: true
      has_many :solutions,
               class_name: "Decidim::Solutions::Solution",
               foreign_key: "decidim_problems_problem_id", dependent: :restrict_with_exception

      scope :published, -> { where.not(published_at: nil) }
      scope :in_proposal, -> { where(state: VALID_STATES.index(:proposal)) }
      scope :in_execution, -> { where(state: VALID_STATES.index(:execution)) }
      scope :in_finished, -> { where(state: VALID_STATES.index(:finished)) }

      searchable_fields({
                          scope_id: "decidim_sectorial_scope_id",
                          participatory_space: :itself,
                          A: :title,
                          B: :description,
                          C: "",
                          D: "",
                          datetime: :published_at,
                        },
                        index_on_create: ->(problem) { problem.published? && problem.visible? },
                        index_on_update: ->(problem) { problem.published? && problem.visible? })

      def published?
        published_at.present?
      end
    end
  end
end
