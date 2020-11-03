# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # A form object used to create challenges from the admin dashboard.
      #
      class ChallengesForm < Decidim::Form
        include TranslatableAttributes

        mimic :challenge

        translatable_attribute :title, String
        translatable_attribute :local_description, String
        translatable_attribute :global_description, String

        attribute :decidim_component_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :tags, String
        attribute :sdg, String
        attribute :state, Integer
        attribute :end_date, Decidim::Attributes::LocalizedDate
        attribute :start_date, Decidim::Attributes::LocalizedDate
        attribute :coordinating_entities, String
        attribute :collaborating_entities, String

        translatable_attribute :title, String do |field, _locale|
          validates field, length: { in: 5..50 }, if: proc { |resource| resource.send(field).present? }
        end
        translatable_attribute :local_description, String
        translatable_attribute :global_description, String

        validates :title, :local_description, :global_description, translatable_presence: true
        validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
        validate :valid_state

        validates :start_date, presence: true, date: { before_or_equal_to: :end_date }
        validates :end_date, presence: true, date: { after_or_equal_to: :start_date }

        alias organization current_organization

        def select_states_collection
          Decidim::Challenges::Challenge::VALID_STATES.map.with_index do |state, idx|
            [I18n.t(state, scope: 'decidim.challenges.states'), idx]
          end
        end

        def select_sdg_collection
          [
            I18n.t('no_poverty.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('zero_hunger.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('good_health.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('quality_education.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('gender_equality.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('clean_water.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('clean_energy.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('decent_work.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('iiai.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('reduced_inequalities.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('sustainable_cities.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('responsible_consumption.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('climate_action.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('life_below_water.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('life_on_land.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('pjsi.objectives.subtitle', scope: 'decidim.components.sdgs'),
            I18n.t('partnership.objectives.subtitle', scope: 'decidim.components.sdgs'),
          ]
        end

        # Finds the Scope from the given decidim_scope_id, uses participatory space scope if missing.
        #
        # Returns a Decidim::Scope
        def scope
          @scope ||= @scope_id ? current_component.scopes.find_by(id: @scope_id) : current_component.scope
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
