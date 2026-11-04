# frozen_string_literal: true

module Decidim
  module Solutions
    # This cell renders the Grid (:g) Solution card
    # for an given instance of a Solution
    class SolutionGCell < Decidim::CardGCell
      include ActiveSupport::NumberHelper
      include Decidim::Solutions::SolutionsHelper
      include Decidim::Sdgs::SdgsHelper
      include Decidim::Solutions::SolutionCellsHelper

      private

      def description
        text = translated_attribute(model.description)
        decidim_sanitize(html_truncate(text, length: 100))
      end

      def show
        render
      end

      def resource_path
        resource_locator(model).path
      end

      def resource_id
        model.id
      end

      def resource_sdg
        if model.problem.present?
          model.problem.challenge.sdg_code
        else
          model.challenge.sdg_code
        end
      end

      def resource_sdg_index
        challenge = model.problem ? model.problem.challenge : model.challenge
        challenge.sdg_code ? (1 + Decidim::Sdgs::Sdg.index_from_code(challenge.sdg_code.to_sym)).to_s.rjust(2, "0") : nil
      end
    end
  end
end
