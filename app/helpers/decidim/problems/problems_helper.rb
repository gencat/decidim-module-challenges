# frozen_string_literal: true

module Decidim
  module Problems
    # Custom helpers, scoped to the problems engine.
    #
    module ProblemsHelper
      def filter_sections
        if has_sdgs?
          [
            { method: :with_any_state, collection: filter_custom_state_values, label_scope: "decidim.shared.filters", id: "state" },
            { method: :with_any_sdgs_codes, collection: filter_sdgs_values, label_scope: "decidim.shared.filters", id: "sdgs" },
          ].reject { |item| item[:collection].blank? }
        else
          [
            { method: :with_any_state, collection: filter_custom_state_values, label_scope: "decidim.shared.filters", id: "state" },
          ].reject { |item| item[:collection].blank? }
        end
      end
    end
  end
end
