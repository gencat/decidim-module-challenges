# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # A form object used to create problems from the admin dashboard.
      #
      class ProblemsForm < Decidim::Form
        include TranslatableAttributes

        mimic :problem

        translatable_attribute :title, String
        translatable_attribute :description, String

        attribute :decidim_component_id, Integer
        attribute :decidim_challenges_challenge_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :tags, String
        attribute :causes, String
        attribute :groups_affected, String
        attribute :state, Integer
        attribute :end_date, Decidim::Attributes::LocalizedDate
        attribute :start_date, Decidim::Attributes::LocalizedDate
        attribute :proposing_entities, String
        attribute :collaborating_entities, String

        translatable_attribute :title, String do |field, _locale|
          validates field, length: { in: 5..50 }, if: proc { |resource| resource.send(field).present? }
        end
        translatable_attribute :description, String

        validates :title, :description, translatable_presence: true
        validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
        validate :valid_state
        validates :decidim_challenges_challenge_id, presence: true

        validates :start_date, presence: true, date: { before_or_equal_to: :end_date }
        validates :end_date, presence: true, date: { after_or_equal_to: :start_date }

        alias organization current_organization

        # Return a problem's valid states list
        def select_states_collection
          Decidim::Problems::Problem::VALID_STATES.map.with_index do |state, idx|
            [I18n.t(state, scope: "decidim.problems.states"), idx]
          end
        end

        # Return a challenge's list
        def select_challenge_collection
          Decidim::Challenges::Challenge.all.map do |ch|
            [translated_attribute(ch.title), ch.id]
          end
        end

        # Finds the Scope from the given decidim_scope_id, uses participatory space scope if missing.
        #
        # Returns a Decidim::Scope
        def scope
          @scope ||= current_organization.scopes.find_by(id: decidim_scope_id)
        end

        # Finds the Challenge from the given decidim_challenges_challenge_id
        #
        # Returns a Decidim::Challenges::Challenge
        def challenge
          @challenge ||= @decidim_challenges_challenge_id ? Decidim::Challenges::Challenge.find(@decidim_challenges_challenge_id) : false
        end

        def map_model(model); end

        private

        def valid_state
          return if state.present? && Decidim::Problems::Problem::VALID_STATES[state].present?

          errors.add(:state, :invalid)
        end
      end
    end
  end
end
