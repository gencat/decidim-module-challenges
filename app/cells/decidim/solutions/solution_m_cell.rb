# frozen_string_literal: true

module Decidim
  module Solutions
    # This cell renders the Medium (:m) Solution card
    # for an given instance of a Solution
    class SolutionMCell < Decidim::CardMCell
      include ActiveSupport::NumberHelper
      include Decidim::Sdgs::SdgsHelper

      private

      def resource_problem_title
        translated_attribute model.problem.title
      end

      def resource_challenge_title
        translated_attribute model.problem.challenge.title
      end

      def resource_icon
        icon "solutions", class: "icon--big"
      end

      def description
        translated_attribute model.description
      end

      def solution_path
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

      def problem_path
        resource_locator(model.problem).path
      end

      def challenge_path
        resource_locator(model.problem.challenge).path
      end

      def resource_sdg
        model.problem.challenge.sdg_code
      end

      def resource_sdg_index
        model.problem.challenge.sdg_code ? (1 + Decidim::Sdgs::Sdg.index_from_code(model.problem.challenge.sdg_code.to_sym)).to_s.rjust(2, "0") : nil
      end

      def current_organization
        current_organization
      end
    end
  end
end
