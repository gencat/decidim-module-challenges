# frozen_string_literal: true

module Decidim
  module ShowFiltersHelper
    def css_full_cardgrid_cols(hide_filters)
      if hide_filters
        "row small-up-1 medium-up-3 card-grid"
      else
        "row small-up-1 medium-up-2 card-grid"
      end
    end
  end
end
