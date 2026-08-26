# frozen_string_literal: true

module Decidim
  module Problems
    # The data store for a Problem in the Decidim::Problems component.
    class Problem < Decidim::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::FilterableResource
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes
      include Decidim::Randomable

      VALID_STATES = [:proposal, :execution, :finished].freeze
      enum :state, VALID_STATES

      component_manifest_name "problems"

      belongs_to :challenge, foreign_key: "decidim_challenges_challenge_id", class_name: "Decidim::Challenges::Challenge"

      has_many :solutions,
               class_name: "Decidim::Solutions::Solution",
               foreign_key: "decidim_problems_problem_id", dependent: :restrict_with_exception

      scope :published, -> { where.not(published_at: nil) }
      scope :in_proposal, -> { where(state: VALID_STATES.index(:proposal)) }
      scope :in_execution, -> { where(state: VALID_STATES.index(:execution)) }
      scope :in_finished, -> { where(state: VALID_STATES.index(:finished)) }

      scope :with_any_state, lambda { |*values|
        where(state: Array(values).map(&:to_sym) & VALID_STATES)
      }

      scope :search_text_cont, lambda { |search_text|
        where("title ->> '#{I18n.locale}' ILIKE ?", "%#{search_text}%")
      }

      scope :with_any_sdgs_codes, lambda { |*values|
        joins(:challenge).where("decidim_challenges_challenges" => { sdg_code: Array(values).map(&:to_sym) })
      }

      def self.ransackable_scopes(_auth_object = nil)
        [:with_any_state, :search_text_cont, :with_any_sdgs_codes, :related_to]
      end

      searchable_fields({
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
