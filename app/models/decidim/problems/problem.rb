# frozen_string_literal: true

module Decidim
  module Problems
    # The data store for a Problem in the Decidim::Problems component.
    class Problem < Problems::ApplicationRecord
      include Decidim::HasComponent
      include Decidim::Loggable
      include Decidim::Resourceable
      include Decidim::ScopableComponent
      include Decidim::Searchable
      include Decidim::Traceable
      include Decidim::TranslatableAttributes

      # FIX define possible states !
      VALID_STATES = %i[proposal executing finished].freeze
      enum state: VALID_STATES

      component_manifest_name 'problems'

      scope :published,   -> { where.not(published_at: nil) }
      scope :in_proposal, -> { where(state: VALID_STATES.index(:proposal)) }
      scope :in_executing, -> { where(state: VALID_STATES.index(:executing)) }
      scope :in_finished, -> { where(state: VALID_STATES.index(:finished)) }

      searchable_fields({
                          scope_id: :decidim_scope_id,
                          participatory_space: :itself,
                          A: :title,
                          B: :description,
                          C: '',
                          D: '',
                          datetime: :published_at
                        },
                        index_on_create: ->(problem) { problem.published? },
                        index_on_update: ->(problem) { problem.published? })

      def published?
        published_at.present?
      end
    end
  end
end
