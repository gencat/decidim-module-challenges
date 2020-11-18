# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # A command with all the business logic when a user updates a Solution.
      class UpdateSolution < Rectify::Command
        # Public: Initializes the command.
        #
        # form         - A form object with the params.
        # solution - the solution to update.
        def initialize(form, solution)
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
          parsed_title = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.title, current_organization: form.current_organization).rewrite
          parsed_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.description, current_organization: form.current_organization).rewrite
          {
            title: parsed_title,
            description: parsed_description,
            component: form.current_component,
            decidim_problems_problem_id: form.decidim_problems_problem_id,
            scope: form.scope,
            tags: form.tags,
            indicators: form.indicators,
            beneficiaries: form.beneficiaries,
            requirements: form.requirements,
            financing_type: form.financing_type
          }
        end
      end
    end
  end
end
