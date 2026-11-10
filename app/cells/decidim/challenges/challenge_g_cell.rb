# frozen_string_literal: true

module Decidim
  module Challenges
    # This cell renders the Grid (:g) Challenge card
    # for an given instance of a Challenge
    class ChallengeGCell < Decidim::CardGCell
      include ActiveSupport::NumberHelper
      include Decidim::Challenges::ChallengesHelper
      include Decidim::Sdgs::SdgsHelper
      include ChallengeCellsHelper

      private

      def resource_image_url
        model.attached_uploader(:card_image).url
      end

      def has_image?
        @has_image ||= model.component.settings.allow_card_image && model.card_image.attached?
      end

      def description
        text = translated_attribute(model.global_description)
        decidim_sanitize(html_truncate(text, length: 100))
      end

      def show
        render
      end

      def resource_path
        resource_locator(model).path
      end

      def resource_sdg
        model.sdg_code
      end

      def resource_sdg_index
        model.sdg_code ? (1 + Decidim::Sdgs::Sdg.index_from_code(model.sdg_code.to_sym)).to_s.rjust(2, "0") : nil
      end

      def resource_state
        model.state
      end
    end
  end
end
