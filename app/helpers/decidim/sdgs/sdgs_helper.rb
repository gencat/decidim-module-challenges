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
    end
  end
end
