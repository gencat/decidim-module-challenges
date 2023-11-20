# frozen_string_literal: true

module Decidim
  module Challenges
    # The data store for a Survey in the Decidim::Challenges component.
    class Survey < Decidim::ApplicationRecord
      include Decidim::DownloadYourData

      belongs_to :challenge, foreign_key: "decidim_challenge_id", class_name: "Decidim::Challenges::Challenge"
      belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"

      validates :user, uniqueness: { scope: :challenge }

      def self.export_serializer
        Decidim::Challenges::DownloadYourDataSurveySerializer
      end
    end
  end
end
