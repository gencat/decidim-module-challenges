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

      def resource_icon
        icon "challenges", class: "icon--big"
      end

      def resource_image_url
        model.attached_uploader(:card_image).url
      end

      def has_image?
        @has_image ||= model.component.settings.allow_card_image && model.card_image.attached?
      end

      def resource_image_path
        @resource_image_path ||= has_image? ? model.attached_uploader(:card_image).path : nil
      end

      def description
        text = translated_attribute(model.global_description)
        decidim_sanitize(html_truncate(text, length: 100))
      end

      def challenge_path
        resource_locator(model).path
      end

      def show
        render
      end

      def resource_path
        resource_locator(model).path
      end

      def resource_title
        translated_attribute model.title
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

      def current_organization
        current_organization
      end
    end
  end
end
