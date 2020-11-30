# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # A form object used to create solutions from the admin dashboard.
      #
      class SolutionsForm < Decidim::Form
        include TranslatableAttributes

        mimic :solution

        translatable_attribute :title, String do |field, _locale|
          validates field, length: { in: 5..50 }, if: proc { |resource| resource.send(field).present? }
        end
        translatable_attribute :description, String

        attribute :decidim_component_id, Integer
        attribute :decidim_problems_problem_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :tags, String
        translatable_attribute :indicators, String
        translatable_attribute :beneficiaries, String
        translatable_attribute :requirements, String
        translatable_attribute :financing_type, String

        validates :title, :description, translatable_presence: true
        validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
        validates :decidim_problems_problem_id, presence: true

        alias organization current_organization

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
      end
    end
  end
end
