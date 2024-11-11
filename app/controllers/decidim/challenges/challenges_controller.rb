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
      include WithSdgs

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper
      helper Decidim::Challenges::ChallengesHelper

      helper_method :challenges, :has_sdgs?

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
        has_sdgs? ? default_filters.merge({ with_any_sdgs_codes: [] }) : default_filter_params
      end

      def challenges
        @challenges ||= reorder(paginate(search.result))
      end

      def search_collection
        ::Decidim::Challenges::Challenge.where(component: current_component).published
      end

      def default_filters
        {
          search_text_cont: "",
          with_any_state: %w(proposal execution finished),
          with_any_scope: nil,
          with_any_sdgs_codes: [],
          with_any_category: nil,
          related_to: "",
        }
      end
    end
  end
end
