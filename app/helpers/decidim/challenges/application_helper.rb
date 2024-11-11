# frozen_string_literal: true

module Decidim
  module Challenges
    # Custom helpers, scoped to the challenges engine.
    #
    module ApplicationHelper
      include PaginateHelper

      def component_name
        i18n_key = "decidim.components.challenges.name"
        (defined?(current_component) && translated_attribute(current_component&.name).presence) || t(i18n_key)
      end

      def filter_sdgs_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.challenges.challenges_helper.filter_state_values.all")),
          Decidim::Sdgs::Sdg::SDGS.map do |sdg_code|
            Decidim::CheckBoxesTreeHelper::TreePoint.new(sdg_code, I18n.t("#{sdg_code}.objectives.subtitle", scope: "decidim.components.sdgs"))
          end
        )
      end

      def filter_custom_state_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.challenges.challenges_helper.filter_state_values.all")),
          [
            Decidim::CheckBoxesTreeHelper::TreePoint.new("proposal", t("decidim.challenges.challenges_helper.filter_state_values.proposal")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("execution", t("decidim.challenges.challenges_helper.filter_state_values.execution")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("finished", t("decidim.challenges.challenges_helper.filter_state_values.finished")),
          ]
        )
      end

      def filter_custom_scopes_values
        filter_scopes_values_from(Decidim::Scope.all)
      end
    end
  end
end
