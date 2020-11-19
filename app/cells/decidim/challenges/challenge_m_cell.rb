# frozen_string_literal: true

module Decidim
  module Challenges
    # This cell renders the Medium (:m) Challenge card
    # for an given instance of a Challenge
    class ChallengeMCell < Decidim::CardMCell
      include ActiveSupport::NumberHelper
      include Decidim::Challenges::ChallengesHelper
      include Decidim::Sdgs::SdgsHelper

      private

      def resource_icon
        icon "challenges", class: "icon--big"
      end

      def description
        translated_attribute model.global_description
      end
      private

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
        if model.sdg_code
          t_sdg(model.sdg_code)
        else
          nil
        end
      end

      def resource_sdg_index
        if model.sdg_code
          (1 + Decidim::Sdgs::Sdg.index_from_code(model.sdg_code.to_sym)).to_s.rjust(2, "0")
        else
          nil
        end
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
