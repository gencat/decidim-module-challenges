# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # A command with all the business logic when a user updates a Solution.
      class UpdateSolution < Decidim::Command
        include Decidim::Challenges
        include Decidim::CommandUtils

        # Public: Initializes the command.
        #
        # form         - A form object with the params.
        # solution - the solution to update.
        def initialize(form, solution)
          super()
          @form = form
          @solution = solution
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the problem.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_solution
          end

          broadcast(:ok, solution)
        end

        private

        attr_reader :form, :solution

        def update_solution
          Decidim.traceability.update!(
            solution,
            form.current_user,
            attributes: attributes
          )
        end

        def attributes
          {
            title: parsed_attribute(:title),
            description: parsed_attribute(:description),
            component: form.current_component,
            decidim_problems_problem_id: form.decidim_problems_problem_id,
            decidim_challenges_challenge_id: challenge_id,
            tags: form.tags,
            objectives: parsed_attribute(:objectives),
            indicators: parsed_attribute(:indicators),
            beneficiaries: parsed_attribute(:beneficiaries),
            requirements: parsed_attribute(:requirements),
            financing_type: parsed_attribute(:financing_type),
          }
        end
      end
    end
  end
end
