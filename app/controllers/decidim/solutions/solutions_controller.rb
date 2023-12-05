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
      include Decidim::Sdgs::SdgsHelper
      include Decidim::ShowFiltersHelper

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper

      helper_method :solutions

      def index
        @solutions = search.result
        @solutions = reorder(solutions)
        @solutions = paginate(solutions)
      end

      def show
        @solution = solution
        if @solution.problem.present?
          @sectorial_scope = sectorial_scope
          @technological_scope = technological_scope
        end
        @sdg_index = sdg_index if @solution.problem.present? || @solution.challenge.present?
        @challenge_scope = challenge_scope
      end

      private

      def default_filter_params
        {
          search_text_cont: "",
          with_any_category: default_filter_category_params,
          with_any_territorial_scope_id: default_filter_scope_params,
          with_related_to: "",
          with_any_sdgs_codes: [],
        }
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
        @solutions ||= paginate(search.result)
      end

      def solution
        @solution ||= Solution.find(params[:id])
      end

      def sdg_index
        challenge = @solution.problem ? @solution.problem.challenge : @solution.challenge
        @sdg_index ||= challenge.sdg_code ? (1 + Decidim::Sdgs::Sdg.index_from_code(challenge.sdg_code.to_sym)).to_s.rjust(2, "0") : nil
      end

      def challenge_scope
        @challenge_scope ||= if @solution.problem.present?
                               current_organization.scopes.find_by(id: @solution.problem.challenge.decidim_scope_id)
                             else
                               current_organization.scopes.find_by(id: @solution.challenge.decidim_scope_id)
                             end
      end

      def sectorial_scope
        @sectorial_scope ||= current_organization.scopes.find_by(id: @solution.problem.decidim_sectorial_scope_id)
      end

      def technological_scope
        @technological_scope ||= current_organization.scopes.find_by(id: @solution.problem.decidim_technological_scope_id)
      end

      def search_collection
        ::Decidim::Solutions::Solution.where(component: current_component).published
      end
    end
  end
end
