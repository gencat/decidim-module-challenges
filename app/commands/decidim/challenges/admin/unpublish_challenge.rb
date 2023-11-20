# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # A command that sets a challenge as unpublished.
      class UnpublishChallenge < Decidim::Command
        # Public: Initializes the command.
        #
        # challenge - A Challenge that will be published
        # current_user - the user performing the action
        def initialize(challenge, current_user)
          super()
          @challenge = challenge
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the data wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if challenge.nil? || !challenge.published?

          Decidim.traceability.perform_action!("unpublish", challenge, current_user) do
            challenge.unpublish!
          end

          broadcast(:ok)
        end

        private

        attr_reader :challenge, :current_user
      end
    end
  end
end
