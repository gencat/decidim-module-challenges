# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # A form object used to create challenges from the admin dashboard.
      #
      class ChallengesForm < Form
        include TranslatableAttributes

        mimic :challenge

        translatable_attribute :title, String
        translatable_attribute :local_description, String
        translatable_attribute :global_description, String

        attribute :tags, String
        attribute :ods, String
        attribute :area_id, Integer
        attribute :status, Integer
        attribute :end_date, Decidim::Attributes::LocalizedDate
        attribute :start_date, Decidim::Attributes::LocalizedDate
        attribute :coord_entity, String
        attribute :col_entity, String

        validates :ods, presence: true, if: proc { |object| object.ods.present? }
        validates :area, presence: true, if: proc { |object| object.area_id.present? }

        alias organization current_organization

        def map_model(model)

        end

        def area
          @area ||= current_organization.areas.find_by(id: area_id)
        end

      end
    end
  end
end
