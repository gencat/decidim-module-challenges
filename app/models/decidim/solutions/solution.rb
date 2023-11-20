# frozen_string_literal: true

module Decidim
  module Solutions
    # The data store for a Solution in the Decidim::Solutions component.
    class Solution < Solutions::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::FilterableResource
      include Decidim::HasCategory
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes
      include Decidim::Randomable

      component_manifest_name "solutions"

      belongs_to :problem, foreign_key: "decidim_problems_problem_id", class_name: "Decidim::Problems::Problem", optional: true
      belongs_to :challenge, foreign_key: "decidim_challenges_challenge_id", class_name: "Decidim::Challenges::Challenge", optional: true

      scope :published, -> { where.not(published_at: nil) }

      scope :search_text_cont, lambda { |search_text|
        where("title ->> '#{I18n.locale}' ILIKE ?", "%#{search_text}%")
      }

      scope :with_any_sdgs_codes, lambda { |*values|
        joins(:challenge).where("decidim_challenges_challenges" => { sdg_code: Array(values).map(&:to_sym) })
      }

      scope :with_any_territorial_scope_id, lambda { |*territorial_scope_id|
        if territorial_scope_id.include?("all")
          all
        else
          clean_scope_ids = territorial_scope_id

          conditions = []
          conditions << "decidim_challenges_challenges.decidim_scope_id IS NULL" if clean_scope_ids.delete("global")
          conditions.concat(["? = ANY(decidim_scopes.part_of)"] * clean_scope_ids.count) if clean_scope_ids.any?

          includes(problem: { challenge: :scope }).references(:decidim_scopes).where(conditions.join(" OR "), *clean_scope_ids.map(&:to_i))
        end
      }

      def self.ransackable_scopes(_auth_object = nil)
        [:search_text_cont, :with_any_category, :with_any_sdgs_codes, :with_any_territorial_scope_id]
      end

      searchable_fields({
                          participatory_space: :itself,
                          A: :title,
                          B: :description,
                          C: "",
                          D: "",
                          datetime: :published_at,
                        },
                        index_on_create: ->(solution) { solution.published? && solution.visible? },
                        index_on_update: ->(solution) { solution.published? && solution.visible? })

      def published?
        published_at.present?
      end
    end
  end
end
