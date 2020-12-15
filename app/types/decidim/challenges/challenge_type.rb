# frozen_string_literal: true

module Decidim
  module Challenges
    ChallengeType = GraphQL::ObjectType.define do
      name "Challenge"
      description "A challenge"

      interfaces [
        # -> { Decidim::Comments::CommentableInterface },
        # -> { Decidim::Core::CoauthorableInterface },
        # -> { Decidim::Core::CategorizableInterface },
        -> { Decidim::Core::ScopableInterface },
        # -> { Decidim::Core::AttachableInterface },
        # -> { Decidim::Core::FingerprintInterface },
        # -> { Decidim::Core::AmendableInterface },
        # -> { Decidim::Core::AmendableEntityInterface },
        # -> { Decidim::Core::TraceableInterface },
        # -> { Decidim::Core::EndorsableInterface },
        # -> { Decidim::Core::TimestampsInterface }
      ]

      field :id, !types.ID
      field :title, !Decidim::Core::TranslatedFieldType, "The title of this challenge (same as the component name)."
      field :local_description, Decidim::Core::TranslatedFieldType, "The local description of this challenge."
      field :global_description, Decidim::Core::TranslatedFieldType, "The global description of this challenge."
      field :tags, Decidim::Core::TranslatedFieldType, "The tags of this challenge."
      field :sdg_code, types.String, "The Sustainable Development Goal this challenge is associated with."

      field :createdAt, !Decidim::Core::DateTimeType, "The time this challenge was created", property: :created_at
      field :updatedAt, !Decidim::Core::DateTimeType, "The time this challenge was updated", property: :updated_at
    end
  end
end


    # t.bigint "decidim_scope_id"
    # t.integer "state", default: 0, null: false
    # t.date "start_date"
    # t.date "end_date"
    # t.datetime "published_at"
    # t.string "coordinating_entities"
    # t.string "collaborating_entities"
    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false