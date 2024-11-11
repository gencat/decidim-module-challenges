# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module WithSdgs
    extend ActiveSupport::Concern

    included do
      private

      def has_sdgs
        sdgs_component = current_component.participatory_space.components.where(manifest_name: "sdgs").where.not(published_at: nil)

        sdgs_component.present?
      end
    end
  end
end
