# frozen_string_literal: true

module Decidim
  module Solutions
    # A command with all the business logic when a user creates a new solution.
    class CreateSolution < Decidim::Command
      include ::Decidim::MultipleAttachmentsMethods
      include Decidim::Challenges
      include Decidim::CommandUtils

      # Public: Initializes the command.
      #
      # form - A form object with the params.
      def initialize(form)
        super()
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the solution.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          create_solution!

          if process_attachments?
            build_attachments
            create_attachments
          end
        end

        broadcast(:ok, solution)
      end

      private

      attr_reader :form, :solution, :attachment

      def create_solution!
        params = {
          title: parsed_attribute(:title),
          description: parsed_attribute(:description),
          component: form.current_component,
          decidim_challenges_challenge_id: challenge_id,
          project_status: parsed_attribute(:project_status),
          project_url: parsed_attribute(:project_url),
          coordinating_entity: parsed_attribute(:coordinating_entity),
          author_id: form.author_id,
        }

        @solution = Decidim.traceability.create!(
          Decidim::Solutions::Solution,
          form.current_user,
          params,
          visibility: "all"
        )

        @attached_to = @solution
      end
    end
  end
end
