# frozen_string_literal: true

module Decidim
  module Solutions
    # Custom helpers, scoped to the challenges engine.
    #
    module SolutionsHelper
      def filter_sections
        [
          { method: :with_any_territorial_scope, collection: filter_global_scopes_values, label_scope: "decidim.shared.filters", id: "sdgs" },
          { method: :with_any_area, collection: filter_areas_values, label_scope: "decidim.shared.filters", id: "sdgs" },
          { method: :with_any_sdgs_codes, collection: filter_sdgs_values, label_scope: "decidim.shared.filters", id: "sdgs" },
        ].reject { |item| item[:collection].blank? }
      end

      def filter_sdgs_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.challenges.challenges_helper.filter_state_values.all")),
          Decidim::Sdgs::Sdg::SDGS.map do |sdg_code|
            Decidim::CheckBoxesTreeHelper::TreePoint.new(sdg_code, I18n.t("#{sdg_code}.objectives.subtitle", scope: "decidim.components.sdgs"))
          end
        )
      end
    end
  end
end
