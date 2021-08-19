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
        if model.problem.present?
          translated_attribute model.problem.challenge.title
        else
          translated_attribute model.challenge.title
        end
      end

      def resource_icon
        icon "solutions", class: "icon--big"
      end

      def description
        text = translated_attribute(model.description)
        decidim_sanitize(html_truncate(text, length: 100))
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
        resource_locator(model.problem).path if model.problem.present?
      end

      def challenge_path
        if model.problem.present?
          resource_locator(model.problem.challenge).path
        else
          resource_locator(model.challenge).path
        end
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

      def current_organization
        current_organization
      end
    end
  end
end
