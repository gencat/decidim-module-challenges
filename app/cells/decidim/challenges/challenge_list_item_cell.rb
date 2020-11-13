# frozen_string_literal: true

module Decidim
    module Challenges
      # This cell renders a horizontal challenge card
      # for an given instance of a challenge in a challenges list
      class ChallengeListItemCell < Decidim::ViewModel
        include ActiveSupport::NumberHelper
        include Decidim::LayoutHelper
        include Decidim::ActionAuthorizationHelper
        include Decidim::Challenges::ApplicationHelper
        include Decidim::Challenges::Engine.routes.url_helpers
  
        delegate :current_user, :current_settings, :current_order, :current_component, :current_participatory_space, to: :parent_controller
  
        private
        
        def challenge_path
          resource_locator(model).path
        end

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
          translated_attribute model.global_description
        end

        def resource_sdg
          
          sgds = [
            I18n.t("no_poverty.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("zero_hunger.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("good_health.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("quality_education.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("gender_equality.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("clean_water.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("clean_energy.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("decent_work.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("iiai.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("reduced_inequalities.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("sustainable_cities.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("responsible_consumption.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("climate_action.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("life_below_water.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("life_on_land.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("pjsi.objectives.subtitle", scope: "decidim.components.sdgs"),
            I18n.t("partnership.objectives.subtitle", scope: "decidim.components.sdgs")
          ]
          sgds[model.sdg]
        end

        def resource_sdg_index
          (model.sdg + 1).to_s.rjust(2, '0')
        end

        def resource_state
          model.state
        end
      end
    end
  end
  