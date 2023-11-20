# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This command deals with destroying a Challenge from the admin panel.
      class DestroyChallenge < Decidim::Command
        # Public: Initializes the command.
        #
        # page - The Challenge to be destroyed.
        def initialize(challenge, current_user)
          super()
          @challenge = challenge
          @current_user = current_user
        end

        # Public: Executes the command.
        #
        # Broadcasts :ok if it got destroyed
        # Broadcasts :has_problems if not destroyed 'cause dependent
        # Broadcasts :invalid if it not destroyed
        def call
          destroy_challenge
          broadcast(:ok)
        rescue ActiveRecord::DeleteRestrictionError
          broadcast(:has_problems)
        rescue ActiveRecord::RecordNotDestroyed
          broadcast(:invalid)
        end

        private

        attr_reader :challenge, :current_user

        def destroy_challenge
          transaction do
            Decidim.traceability.perform_action!(
              "delete",
              challenge,
              current_user
            ) do
              challenge.destroy!
            end
          end
        end
      end
    end
  end
end
