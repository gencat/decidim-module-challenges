# frozen_string_literal: true

module Decidim
  module Challenges
    # The data store for a Survey in the Decidim::Challenges component.
    class Survey < Decidim::ApplicationRecord
      include Decidim::DownloadYourData

      belongs_to :challenge, foreign_key: "decidim_challenge_id", class_name: "Decidim::Challenges::Challenge"
      belongs_to :author,
                 polymorphic: true,
                 foreign_key: "decidim_author_id",
                 foreign_type: "decidim_author_type"

      validates :decidim_author_id, uniqueness: { scope: :decidim_challenge_id }

      def self.export_serializer
        Decidim::Challenges::DownloadYourDataSurveySerializer
      end
    end
  end
end
