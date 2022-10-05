# frozen_string_literal: true

require_dependency "decidim/components/namer"
require "decidim/solutions/admin"
require "decidim/solutions/engine"
require "decidim/solutions/admin_engine"

# Sustainable Development Goals
Decidim.register_component(:solutions) do |component|
  component.engine = Decidim::Solutions::Engine
  component.admin_engine = Decidim::Solutions::AdminEngine
  component.icon = "media/images/decidim_challenges_icon.svg"
  component.stylesheet = "decidim/solutions/solutions"

  # component.on(:before_destroy) do |instance|
  #   # Code executed before removing the component
  # end

  component.permissions_class_name = "Decidim::Solutions::Permissions"

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  component.query_type = "Decidim::Solutions::SolutionsType"

  component.settings(:global) do |settings|
    # Add your global settings
    # Available types: :integer, :boolean
    settings.attribute :hide_filters, type: :boolean, default: false
  end

  # component.settings(:step) do |settings|
  #   # Add your settings per step
  # end

  component.register_resource(:solution) do |resource|
    # Register a optional resource that can be references from other resources.
    resource.model_class_name = "Decidim::Solutions::Solution"
    resource.card = "decidim/solutions/solution"
    # resource.template = "decidim/solutions/some_resources/linked_some_resources"
    resource.searchable = true
  end

  # component.register_stat :some_stat do |context, start_at, end_at|
  #   # Register some stat number to the application
  # end

  # component.seeds do |participatory_space|
  #   # Add some seeds for this component
  # end
end
