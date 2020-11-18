# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # A form object used to create solutions from the admin dashboard.
      #
      class SolutionsForm < Decidim::Form
        include TranslatableAttributes

        mimic :solution

        translatable_attribute :title, String
        translatable_attribute :description, String

        attribute :decidim_component_id, Integer
        attribute :decidim_problems_problem_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :tags, String
        attribute :indicators, String
        attribute :beneficiaries, String
        attribute :requirements, Integer
        attribute :financing_type, String

        translatable_attribute :title, String do |field, _locale|
          validates field, length: { in: 5..50 }, if: proc { |resource| resource.send(field).present? }
        end
        translatable_attribute :description, String

        validates :title, :description, translatable_presence: true
        validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
        validate :valid_requirements
        validates :decidim_problems_problem_id, presence: true

        alias organization current_organization

        # Return a solution's valid requirements list
        def select_requirements_collection
          Decidim::Solutions::Solution::VALID_REQUIREMENTS.map.with_index do |requirement, idx|
            [I18n.t(requirement, scope: "decidim.solutions.requirements"), idx]
          end
        end

        # Return a problem's list
        def select_problem_collection
          Decidim::Problems::Problem.all.map do |p|
            [translated_attribute(p.title), p.id]
          end
        end

        # Finds the Scope from the given decidim_scope_id, uses participatory space scope if missing.
        #
        # Returns a Decidim::Scope
        def scope
          @scope ||= current_organization.scopes.find_by(id: decidim_scope_id)
        end

        # Finds the Problem from the given decidim_problems_problem_id
        #
        # Returns a Decidim::Problems::Problem
        def problem
          @problem ||= @decidim_problems_problem_id ? Decidim::Problems::Problem.find(@decidim_problems_problem_id) : false
        end

        def map_model(model); end

        private

        def valid_requirements
          return if requirements.present? && Decidim::Solutions::Solution::VALID_REQUIREMENTS[requirements].present?

          errors.add(:requirements, :invalid)
        end
      end
    end
  end
end
