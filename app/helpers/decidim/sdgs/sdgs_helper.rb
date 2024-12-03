# frozen_string_literal: true

module Decidim
  module Sdgs
    # Custom helpers, scoped to the Sdgs engine.
    #
    module SdgsHelper
      def sdgs_filter_selector(form)
        render partial: "decidim/sdgs/sdgs_filter/filter_selector", locals: { form: }
      end

      def t_sdg(code)
        return if code.blank?

        t(code, scope: "decidim.sdgs.names")
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
