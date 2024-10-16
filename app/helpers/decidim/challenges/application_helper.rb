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
    end
  end
end
