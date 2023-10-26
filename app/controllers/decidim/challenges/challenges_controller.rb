# frozen_string_literal: true

module Decidim
  module Challenges
    # Controller that allows browsing challenges.
    #
    class ChallengesController < Decidim::Challenges::ApplicationController
      include Decidim::ApplicationHelper
      include FilterResource
      include Paginable
      include OrderableChallenges
      include ChallengesHelper
      include Decidim::Sdgs::SdgsHelper
      include Decidim::ShowFiltersHelper

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper

      helper_method :challenges

      def index
        @challenges = search.result
        @challenges = reorder(challenges)
        @challenges = paginate(challenges)
      end

      def show
        @challenge = Challenge.find(params[:id])
        @challenge_scope = challenge_scope
        @sdg = @challenge.sdg_code if @challenge.sdg_code.present?
        @sdg_index = (1 + Decidim::Sdgs::Sdg.index_from_code(@challenge.sdg_code.to_sym)).to_s.rjust(2, "0") if @sdg
      end

      private

      def challenge_scope
        @challenge_scope ||= current_organization.scopes.find_by(id: @challenge.decidim_scope_id)
      end

      def default_filter_params
        {
          search_text_cont: "",
          with_any_category_id: default_filter_category_params,
          with_any_state: %w(proposal execution finished),
          with_any_scope_id: default_filter_scope_params,
          with_related_to: "",
          with_any_sdgs_codes: [],
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

      def challenges
        @challenges ||= paginate(search.result)
      end

      def search_collection
        ::Decidim::Challenges::Challenge.published
      end
    end
  end
end
