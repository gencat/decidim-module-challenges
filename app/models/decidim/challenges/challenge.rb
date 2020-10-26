# frozen_string_literal: true

module Decidim
  module Challenges
    # The data store for a Challenge in the Decidim::Challenges component.
    class Challenge < Challenges::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Resourceable
      include Decidim::ScopableComponent
      include Decidim::Traceable
      include Decidim::TranslatableAttributes
      # include Decidim::TranslatableResource

      # translatable_fields :title, :local_description, :global_description

      VALID_STATES = %i[proposal executing finished].freeze
      enum state: VALID_STATES

      component_manifest_name 'challenges'
    end
  end
end
