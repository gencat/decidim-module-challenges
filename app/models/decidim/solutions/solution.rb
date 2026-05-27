# frozen_string_literal: true

module Decidim
  module Solutions
    # The data store for a Solution in the Decidim::Solutions component.
    class Solution < Solutions::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::FilterableResource
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes
      include Decidim::Randomable
      include Decidim::HasAttachments
      include Decidim::Publicable

      component_manifest_name "solutions"

      belongs_to :problem, foreign_key: "decidim_problems_problem_id", class_name: "Decidim::Problems::Problem", optional: true
      belongs_to :challenge, foreign_key: "decidim_challenges_challenge_id", class_name: "Decidim::Challenges::Challenge", optional: true
      belongs_to :author, class_name: "Decidim::User"

      scope :published, -> { where.not(published_at: nil) }

      scope :search_text_cont, lambda { |search_text|
        where("title ->> '#{I18n.locale}' ILIKE ?", "%#{search_text}%")
      }

      scope :with_any_sdgs_codes, lambda { |*values|
        joins(:challenge).where("decidim_challenges_challenges" => { sdg_code: Array(values).map(&:to_sym) })
      }

      def self.ransackable_scopes(_auth_object = nil)
        [:search_text_cont, :with_any_sdgs_codes, :related_to]
      end

      def self.ransackable_attributes(_auth_object = nil)
        %w(author_id beneficiaries coordinating_entity created_at decidim_challenges_challenge_id decidim_component_id decidim_problems_problem_id
           description financing_type id indicators objectives project_status project_url published_at requirements tags title updated_at)
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
