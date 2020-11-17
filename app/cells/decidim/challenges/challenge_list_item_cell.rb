# frozen_string_literal: true

module Decidim
  module Challenges
    # This cell renders a horizontal challenge card
    # for an given instance of a challenge in a challenges list
    class ChallengeListItemCell < Decidim::Challenges::ChallengeCell

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

      def resource_description
        translated_attribute model.global_description
      end

      def resource_sdgs
        Decidim::Sdgs::Sdg::SDGS.map do |sdg_name|
          [I18n.t("#{sdg_name}.objectives.subtitle", scope: "decidim.components.sdgs")]
        end
      end

      def resource_sdg
        if model.sdg
          resource_sdgs[model.sdg]
        else
          nil
        end
      end

      def resource_sdg_index
        if model.sdg
          (1 + model.sdg).to_s.rjust(2, "0")
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
