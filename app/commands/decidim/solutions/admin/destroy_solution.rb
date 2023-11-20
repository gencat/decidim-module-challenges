# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # This command deals with destroying a Solution from the admin panel.
      class DestroySolution < Decidim::Command
        # Public: Initializes the command.
        #
        # page - The Solution to be destroyed.
        def initialize(solution, current_user)
          super()
          @solution = solution
          @current_user = current_user
        end

        # Public: Executes the command.
        #
        # Broadcasts :ok if it got destroyed
        def call
          destroy_solution
          broadcast(:ok)
        end

        private

        attr_reader :solution, :current_user

        def destroy_solution
          transaction do
            Decidim.traceability.perform_action!(
              "delete",
              solution,
              current_user
            ) do
              solution.destroy!
            end
          end
        end
      end
    end
  end
end
