# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This command is executed when the user updates the challenge survey,
      class UpdateSurveys < Decidim::Command
        # Initializes a UpdateSurveys Command.
        #
        # form - The form from which to get the data.
        # challenge - The current instance of the challenge to be updated.
        def initialize(form, challenge)
          super()
          @form = form
          @challenge = challenge
        end

        # Updates the challenge if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          challenge.with_lock do
            update_challenge_surveys
          end

          broadcast(:ok)
        end

        private

        attr_reader :form, :challenge

        def update_challenge_surveys
          challenge.survey_enabled = form.survey_enabled

          challenge.save!
        end
      end
    end
  end
end
