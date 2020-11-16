# frozen_string_literal: true

module Decidim
  module Sdgs
    # The data store for a Sdg in the Decidim::Sdgs component.
    class Sdg < Sdgs::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Publicable
      include Decidim::Resourceable
      include Decidim::ScopableComponent
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      SDGS = [
        :no_poverty,
        :zero_hunger,
        :good_health,
        :quality_education,
        :gender_equality,
        :clean_water,
        :clean_energy,
        :decent_work,
        :iiai,
        :reduced_inequalities,
        :sustainable_cities,
        :responsible_consumption,
        :climate_action,
        :life_below_water,
        :life_on_land,
        :pjsi,
        :partnership
      ].freeze

      enum sdg_name: SDGS

      component_manifest_name "sdgs"
    end
  end
end
