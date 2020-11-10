# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # A command with all the business logic when a user updates a challenge.
      class UpdateChallenge < Rectify::Command
        # Public: Initializes the command.
        #
        # form         - A form object with the params.
        # challenge - the challenge to update.
        def initialize(form, challenge)
          @form = form
          @challenge = challenge
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the challenge.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_challenge
          end

          broadcast(:ok, challenge)
        end

        private

        attr_reader :form, :challenge

        def update_challenge
          Decidim.traceability.update!(
            challenge,
            form.current_user,
            attributes: attributes
          )
        end

        def attributes
          parsed_title = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.title, current_organization: form.current_organization).rewrite
          parsed_local_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.local_description, current_organization: form.current_organization).rewrite
          parsed_global_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.global_description, current_organization: form.current_organization).rewrite
          {
            title: parsed_title,
            local_description: parsed_local_description,
            global_description: parsed_global_description,
            component: form.current_component,
            tags: form.tags,
            sdg: form.sdg,
            scope: form.decidim_scope_id,
            state: form.state,
            start_date: form.start_date,
            end_date: form.end_date,
            coordinating_entities: form.coordinating_entities,
            collaborating_entities: form.collaborating_entities
          }
        end
      end
    end
  end
end
