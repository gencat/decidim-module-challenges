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

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper

      helper_method :challenges

      def index; end

      def show
        @challenge = Challenge.find(params[:id])
        @sdg = sdgs[@challenge.sdg]
      end

      private

      def default_filter_params
        {
          search_text: "",
          category_id: default_filter_category_params,
          state: %w(proposal execution finished),
          scope_id: default_filter_scope_params,
          related_to: "",
          sdgs_codes: []
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
        @challenges ||= paginate(search.results.published)
      end

      def search_klass
        Decidim::Challenges::ChallengeSearch
      end

      def sdgs
        Decidim::Sdgs::Sdg::SDGS.map do |sdg_name|
          I18n.t("#{sdg_name}.objectives.subtitle", scope: "decidim.components.sdgs")
        end
      end
    end
  end
end
