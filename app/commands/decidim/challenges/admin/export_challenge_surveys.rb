# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This command is executed when the user exports the registrations of
      # a Meeting from the admin panel.
      class ExportChallengeSurveys < Decidim::Command
        # challenge - The current instance of the page to be closed.
        # format - a string representing the export format
        # current_user - the user performing the action
        def initialize(challenge, format, current_user)
          super()
          @challenge = challenge
          @format = format
          @current_user = current_user
        end

        # Exports the challenge registrations.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          broadcast(:ok, export_data)
        end

        private

        attr_reader :current_user, :challenge, :format

        def export_data
          Decidim.traceability.perform_action!(
            :export_surveys,
            challenge,
            current_user
          ) do
            Decidim::Exporters
              .find_exporter(format)
              .new(challenge.surveys, Decidim::Challenges::SurveySerializer)
              .export
          end
        end
      end
    end
  end
end
