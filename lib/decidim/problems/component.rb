# frozen_string_literal: true

require_dependency 'decidim/components/namer'
require 'decidim/problems/admin'
require 'decidim/problems/engine'
require 'decidim/problems/admin_engine'

# Sustainable Development Goals
Decidim.register_component(:problems) do |component|
  component.engine = Decidim::Problems::Engine
  component.admin_engine = Decidim::Problems::AdminEngine
  component.icon = 'decidim/problems/icon.svg'

  # component.on(:before_destroy) do |instance|
  #   # Code executed before removing the component
  # end

  component.permissions_class_name = 'Decidim::Problems::Permissions'

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  # component.settings(:global) do |settings|
  #   # Add your global settings
  #   # Available types: :integer, :boolean
  #   # settings.attribute :vote_limit, type: :integer, default: 0
  # end

  # component.settings(:step) do |settings|
  #   # Add your settings per step
  # end

  component.register_resource(:problem) do |resource|
    # Register a optional resource that can be references from other resources.
    resource.model_class_name = 'Decidim::Problems::Problem'
    resource.card = 'decidim/problems/problem'
    # resource.template = "decidim/problems/some_resources/linked_some_resources"
    resource.searchable = true
  end

  # component.register_stat :some_stat do |context, start_at, end_at|
  #   # Register some stat number to the application
  # end

  # component.seeds do |participatory_space|
  #   # Add some seeds for this component
  # end
end
