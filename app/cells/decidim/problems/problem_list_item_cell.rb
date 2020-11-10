# frozen_string_literal: true

module Decidim
    module Problems
        # This cell renders a horizontal problem card
        # for an given instance of a problem in a problems list
        class ProblemListItemCell < Decidim::ViewModel
            include ActiveSupport::NumberHelper
            include Decidim::LayoutHelper
            include Decidim::ActionAuthorizationHelper
            include Decidim::Problems::ApplicationHelper
            include Decidim::Problems::Engine.routes.url_helpers

            delegate :current_user, :current_settings, :current_order, :current_component, :current_participatory_space, to: :parent_controller

            private

            def show
                render
            end

            def resource_path
                resource_locator(model).path
            end

            def resource_title
                translated_attribute model.title
            end

            def resource_description
                translated_attribute model.description
            end

            def resource_state
                model.state
            end
        end
    end
  end
