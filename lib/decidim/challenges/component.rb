# frozen_string_literal: true

require_dependency "decidim/components/namer"
require "decidim/challenges/admin"
require "decidim/challenges/engine"
require "decidim/challenges/admin_engine"

# Sustainable Development Goals
Decidim.register_component(:challenges) do |component|
  component.engine = Decidim::Challenges::Engine
  component.stylesheet = "decidim/challenges/challenges"
  component.admin_engine = Decidim::Challenges::AdminEngine
  component.icon = "media/images/decidim_challenges_icon.svg"

  component.data_portable_entities = ["Decidim::Challenges::Survey"]

  # component.on(:before_destroy) do |instance|
  #   # Code executed before removing the component
  # end

  component.permissions_class_name = "Decidim::Challenges::Permissions"

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  component.query_type = "Decidim::Challenges::ChallengesType"

  component.settings(:global) do |settings|
    # Available types: :integer, :boolean
    settings.attribute :announcement, type: :text, translated: true, editor: true
    settings.attribute :hide_filters, type: :boolean, default: false
    settings.attribute :allow_card_image, type: :boolean, default: false
  end

  component.settings(:step) do |settings|
    settings.attribute :announcement, type: :text, translated: true, editor: true
  end

  component.register_resource(:challenge) do |resource|
    # Register a optional resource that can be references from other resources.
    resource.model_class_name = "Decidim::Challenges::Challenge"
    resource.card = "decidim/challenges/challenge"
    # resource.template = "decidim/challenges/some_resources/linked_some_resources"
    resource.searchable = true
  end

  # component.register_stat :some_stat do |context, start_at, end_at|
  #   # Register some stat number to the application
  # end

  component.seeds do |participatory_space|
    # Add some seeds for this component
  end

  component.exports :answers do |exports|
    exports.collection do |_f, _user, resource_id|
      questionnaire = Decidim::Forms::Questionnaire.find(resource_id)
      Decidim::Forms::QuestionnaireUserAnswers.for(questionnaire)
    end

    exports.formats %w(CSV JSON Excel FormPDF)

    exports.serializer Decidim::Forms::UserAnswersSerializer
  end
end
