# frozen_string_literal: true

module Decidim
  module Problems
    # This cell renders the Medium (:m) problem card
    # for an given instance of a Problem
    class ProblemMCell < Decidim::CardMCell
      include ActiveSupport::NumberHelper
      include Decidim::Problems::ProblemsHelper
      include Decidim::Sdgs::SdgsHelper

      def resource_icon
        icon "problems", class: "icon--big"
      end

      def show
        render
      end

      def problem_path
        resource_locator(model).path
      end

      def challenge_path
        resource_locator(model.challenge).path
      end

      def resource_title
        translated_attribute model.title
      end

      def resource_description
        text = translated_attribute(model.description)
        decidim_sanitize(html_truncate(text, length: 100))
      end

      def resource_state
        model.state
      end

      def problem
        model
      end

      def resource_challenge_title
        translated_attribute model.challenge.title
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
