# frozen_string_literal: true

module Decidim
  module Problems
    # The data store for a Problem in the Decidim::Problems component.
    class Problem < Decidim::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::FilterableResource
      include Decidim::ScopableResource
      include Decidim::HasCategory
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

      scope :with_any_state, lambda { |*values|
        where(state: Array(values).map(&:to_sym) & VALID_STATES)
      }

      scope :search_text_cont, lambda { |search_text|
        where("title ->> '#{I18n.locale}' ILIKE ?", "%#{search_text}%")
      }

      scope :with_any_sdgs_codes, lambda { |*values|
        joins(:challenge).where("decidim_challenges_challenges" => { sdg_code: Array(values).map(&:to_sym) })
      }

      scope :with_any_sectorial_scope_id, lambda { |*sectorial_scope_id|
        if sectorial_scope_id.include?("all")
          all
        else
          clean_scope_ids = sectorial_scope_id

          conditions = []
          conditions << "#{model_name.plural}.decidim_sectorial_scope_id IS NULL" if clean_scope_ids.delete("global")
          conditions.concat(["? = ANY(decidim_scopes.part_of)"] * clean_scope_ids.count) if clean_scope_ids.any?

          includes(:sectorial_scope).references(:decidim_scopes).where(conditions.join(" OR "), *clean_scope_ids.map(&:to_i))
        end
      }

      scope :with_any_technological_scope_id, lambda { |*technological_scope_id|
        if technological_scope_id.include?("all")
          all
        else
          clean_scope_ids = technological_scope_id

          conditions = []
          conditions << "#{model_name.plural}.decidim_technological_scope_id IS NULL" if clean_scope_ids.delete("global")
          conditions.concat(["? = ANY(decidim_scopes.part_of)"] * clean_scope_ids.count) if clean_scope_ids.any?

          includes(:technological_scope).references(:decidim_scopes).where(conditions.join(" OR "), *clean_scope_ids.map(&:to_i))
        end
      }

      scope :with_any_territorial_scope_id, lambda { |*territorial_scope_id|
        if territorial_scope_id.include?("all")
          all
        else
          clean_scope_ids = territorial_scope_id

          conditions = []
          conditions << "decidim_challenges_challenges.decidim_scope_id IS NULL" if clean_scope_ids.delete("global")
          conditions.concat(["? = ANY(decidim_scopes.part_of)"] * clean_scope_ids.count) if clean_scope_ids.any?

          includes(challenge: :scope).references(:decidim_scopes).where(conditions.join(" OR "), *clean_scope_ids.map(&:to_i))
        end
      }

      def self.ransackable_scopes(_auth_object = nil)
        [:with_any_state, :search_text_cont, :with_any_sdgs_codes, :with_any_category,
         :with_any_sectorial_scope_id, :with_any_technological_scope_id, :with_any_territorial_scope_id]
      end

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
