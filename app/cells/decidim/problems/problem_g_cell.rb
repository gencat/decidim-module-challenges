# frozen_string_literal: true

module Decidim
  module Problems
    # This cell renders the Grid (:g) Problem card
    # for an given instance of a Problem
    class ProblemGCell < Decidim::CardGCell
      include ActiveSupport::NumberHelper
      include Decidim::Problems::ProblemsHelper
      include Decidim::Sdgs::SdgsHelper
      include ProblemCellsHelper

      private

      def show
        render
      end

      def description
        text = translated_attribute(model.description)
        decidim_sanitize(html_truncate(text, length: 100))
      end

      def resource_state
        model.state
      end

      def resource_sdg
        model.challenge.sdg_code
      end

      def resource_sdg_index
        model.challenge.sdg_code ? (1 + Decidim::Sdgs::Sdg.index_from_code(model.challenge.sdg_code.to_sym)).to_s.rjust(2, "0") : nil
      end
    end
  end
end
