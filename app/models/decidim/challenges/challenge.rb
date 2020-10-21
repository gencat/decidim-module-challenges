# frozen_string_literal: true

module Decidim
  module Challenges
    # The data store for a Challenge in the Decidim::Challenges component.
    class Challenge < Challenges::ApplicationRecord
      include Decidim::Resourceable
      include Decidim::HasComponent
      include Decidim::ScopableComponent
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      # translatable_fields :title, :local_description, :global_description
      VALID_STATES = %i[proposal executing finished].freeze
      enum state: VALID_STATES

      # belongs_to :area,
      #            foreign_key: "decidim_area_id",
      #            class_name: "Decidim::Area",
      #            optional: true

      component_manifest_name 'challenges'

      # TODO
      # searchable_fields({
      #                    scope_id: :decidim_scope_id,
      #                    participatory_space: :itself,
      #                    A: :title,
      #                    B: :local_description,
      #                    C: :global_description,
      #                    D: '', # TODO
      #                    datetime: :published_at
      #                  },
      #                  index_on_create: ->(_process) { false },
      #                  index_on_update: ->(process) { process.visible? })
      #
      # # Allow ransacker to search for a key in a hstore column (`title`.`en`)
      # ransacker :title do |parent|
      #  Arel::Nodes::InfixOperation.new("->>", parent.table[:title], Arel::Nodes.build_quoted(I18n.locale.to_s))
      # end
    end
  end
end
