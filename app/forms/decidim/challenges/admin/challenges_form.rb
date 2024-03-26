# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # A form object used to create challenges from the admin dashboard.
      #
      class ChallengesForm < Decidim::Form
        include TranslatableAttributes
        include Decidim::Sdgs::SdgsHelper
        include Decidim::HasUploadValidations

        mimic :challenge

        translatable_attribute :title, String do |field, _locale|
          validates field, length: { in: 5..150 }, if: proc { |resource| resource.send(field).present? }
        end
        translatable_attribute :local_description, String
        translatable_attribute :global_description, String

        attribute :decidim_component_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :tags, String
        attribute :sdg_code, String
        attribute :state, Integer
        attribute :end_date, Decidim::Attributes::LocalizedDate
        attribute :start_date, Decidim::Attributes::LocalizedDate
        attribute :coordinating_entities, String
        attribute :collaborating_entities, String

        attribute :card_image
        attribute :remove_card_image, Boolean, default: false

        validates :title, :local_description, :global_description, translatable_presence: true
        validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
        validate :valid_state

        validates :start_date, presence: true, date: { before_or_equal_to: :end_date }
        validates :end_date, presence: true, date: { after_or_equal_to: :start_date }

        validates :card_image,
                  presence: false,
                  passthru: { to: Decidim::Attachment }

        alias organization current_organization

        def select_states_collection
          Decidim::Challenges::Challenge::VALID_STATES.map.with_index do |state, idx|
            [I18n.t(state, scope: "decidim.challenges.states"), idx]
          end
        end

        def select_sdg_collection
          Decidim::Sdgs::Sdg::SDGS.map do |sdg_code|
            [I18n.t("#{sdg_code}.objectives.subtitle", scope: "decidim.components.sdgs"), sdg_code]
          end
        end

        # Finds the Scope from the given decidim_scope_id, uses participatory space scope if missing.
        #
        # Returns a Decidim::Scope
        def scope
          @scope ||= current_organization.scopes.find_by(id: decidim_scope_id)
        end

        def map_model(model); end

        private

        def valid_state
          return if state && Decidim::Challenges::Challenge::VALID_STATES[state].present?

          errors.add(:state, :invalid)
        end
      end
    end
  end
end
