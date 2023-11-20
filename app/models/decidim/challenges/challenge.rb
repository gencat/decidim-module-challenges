# frozen_string_literal: true

module Decidim
  module Challenges
    # The data store for a Challenge in the Decidim::Challenges component.
    class Challenge < Decidim::ApplicationRecord
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
      include Decidim::Forms::HasQuestionnaire
      include Decidim::Randomable
      include Decidim::HasUploadValidations

      belongs_to :scope,
                 foreign_key: "decidim_scope_id",
                 class_name: "Decidim::Scope",
                 optional: true

      has_many :surveys, class_name: "Decidim::Challenges::Survey", foreign_key: "decidim_challenge_id", dependent: :destroy

      VALID_STATES = [:proposal, :execution, :finished].freeze
      enum state: VALID_STATES

      has_many :problems,
               class_name: "Decidim::Problems::Problem",
               foreign_key: "decidim_challenges_challenge_id", dependent: :restrict_with_exception
      has_many :solutions,
               class_name: "Decidim::Solutions::Solution",
               foreign_key: "decidim_challenges_challenge_id", dependent: :restrict_with_exception

      component_manifest_name "challenges"

      has_one_attached :card_image
      validates_upload :card_image, uploader: Decidim::ImageUploader

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
        where(sdg_code: Array(values).map(&:to_sym))
      }

      def self.ransackable_scopes(_auth_object = nil)
        [:with_any_state, :search_text_cont, :with_any_sdgs_codes, :with_any_scope, :with_any_category]
      end

      searchable_fields({
                          scope_id: :decidim_scope_id,
                          participatory_space: :itself,
                          A: :title,
                          B: :local_description,
                          C: :global_description,
                          D: "",
                          datetime: :published_at,
                        },
                        index_on_create: ->(challenge) { challenge.published? && challenge.visible? },
                        index_on_update: ->(challenge) { challenge.published? && challenge.visible? })

      def published?
        published_at.present?
      end

      def remove_card_image; end
    end
  end
end
