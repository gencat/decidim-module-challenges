# frozen_string_literal: true

module Decidim
  module Solutions
    # Custom helpers, scoped to the solutions engine.
    #
    module ApplicationHelper
      include Decidim::RichTextEditorHelper

      def text_editor_for_description(form)
        options = {
          class: "js-hashtags",
          hashtaggable: true,
          value: form_presenter.description(extras: false).strip
        }

        text_editor_for(form, :description, options)
      end

      def participatory_space_challenges
        challenge_component = current_participatory_space.components.find_by(manifest_name: "challenges")

        ::Decidim::Challenges::Challenge.where(decidim_component_id: challenge_component.id)
      end
    end
  end
end
