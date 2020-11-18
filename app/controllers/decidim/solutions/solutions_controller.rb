# frozen_string_literal: true

module Decidim
  module Solutions
    # Controller that allows browsing solutions.
    #
    class SolutionsController < Decidim::Solutions::ApplicationController
      include Decidim::ApplicationHelper
      include FilterResource
      include Paginable
      include OrderableSolutions
      include SolutionsHelper

      helper Decidim::CheckBoxesTreeHelper

      helper_method :solutions

      def index; end

      private

      def default_filter_params
        {
          search_text: "",
          category_id: default_filter_category_params,
          state: Decidim::Solutions::Solution::VALID_REQUIREMENTS,
          scope_id: default_filter_scope_params,
          related_to: ""
        }
      end

      def default_filter_category_params
        return "all" unless current_component.participatory_space.categories.any?

        ["all"] + current_component.participatory_space.categories.map { |category| category.id.to_s }
      end

      def default_filter_scope_params
        return "all" unless current_component.participatory_space.scopes.any?

        if current_component.participatory_space.scope
          ["all", current_component.participatory_space.scope.id] + current_component.participatory_space.scope.children.map { |scope| scope.id.to_s }
        else
          %w(all global) + current_component.participatory_space.scopes.map { |scope| scope.id.to_s }
        end
      end

      def solutions
        @solutions ||= paginate(search.results.published)
      end

      def search_klass
        Decidim::Solutions::SolutionSearch
      end
    end
  end
end
