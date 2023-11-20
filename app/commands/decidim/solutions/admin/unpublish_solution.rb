# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # A command that sets a solution as unpublished.
      class UnpublishSolution < Decidim::Command
        # Public: Initializes the command.
        #
        # solution - A Solution that will be published
        # current_user - the user performing the action
        def initialize(solution, current_user)
          super()
          @solution = solution
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the data wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if solution.nil? || !solution.published?

          Decidim.traceability.perform_action!("unpublish", solution, current_user) do
            solution.unpublish!
          end

          broadcast(:ok)
        end

        private

        attr_reader :solution, :current_user
      end
    end
  end
end
