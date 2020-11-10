# frozen_string_literal: true

module Decidim
  module Challenges
    # The data store for a Challenge in the Decidim::Challenges component.
    class Challenge < Challenges::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Resourceable
      include Decidim::ScopableComponent
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      # translatable_fields :title, :local_description, :global_description

      VALID_STATES = %i[proposal executing finished].freeze
      enum state: VALID_STATES

      component_manifest_name 'challenges'

      scope :published,   -> { where.not(published_at: nil) }
      scope :in_proposal, -> { where(state: VALID_STATES.index(:proposal)) }
      scope :in_executing, -> { where(state: VALID_STATES.index(:executing)) }
      scope :in_finished, -> { where(state: VALID_STATES.index(:finished)) }

      searchable_fields({
                          scope_id: :decidim_scope_id,
                          participatory_space: :itself,
                          A: :title,
                          B: :local_description,
                          C: :global_description,
                          D: '',
                          datetime: :published_at
                        },
                        index_on_create: ->(challenge) { challenge.published? },
                        index_on_update: ->(challenge) { challenge.published? })

      # # Allow ransacker to search for a key in a hstore column (`title`.`en`)
      # ransacker :title do |parent|
      #  Arel::Nodes::InfixOperation.new("->>", parent.table[:title], Arel::Nodes.build_quoted(I18n.locale.to_s))
      # end

      def published?
        published_at.present?
      end
    end
  end
end
