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
        @challenges = reorder(@challenges)
        @challenges = paginate(@challenges)
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
          with_any_category: default_filter_category_params,
          with_any_state: %w(proposal execution finished),
          with_any_scope: default_filter_scope_params,
          with_related_to: "",
          with_any_sdgs_codes: [],
        }
      end

      def challenges
        @challenges ||= reorder(paginate(search.result))
      end

      def search_collection
        ::Decidim::Challenges::Challenge.where(component: current_component).published
      end
    end
  end
end
