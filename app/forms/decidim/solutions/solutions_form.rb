# frozen_string_literal: true

module Decidim
  module Solutions
    # A form object to be used when public users want to create a solution.
    #
    class SolutionsForm < Decidim::Form
      include Decidim::AttachmentAttributes
      include Decidim::HasUploadValidations

      mimic :solution

      attribute :title, String
      attribute :description, Decidim::Attributes::CleanString
      attribute :project_status, String
      attribute :project_url, String
      attribute :coordinating_entity, String
      attribute :decidim_challenges_challenge_id, Integer
      attribute :decidim_problems_problem_id, Integer
      attribute :author_id, Integer
      attribute :attachment, AttachmentForm

      attachments_attribute :documents

      validates :title, :description, presence: true, etiquette: true
      validates :project_status, :coordinating_entity, presence: true
      validates :decidim_challenges_challenge_id, :author_id, presence: true
      validates :decidim_problems_problem_id, presence: false

      def map_model(model)
        self.title = translated_attribute(model.title)
        self.description = translated_attribute(model.description)

        self.documents = model.attachments
        nil unless model.categorization
      end

      # Finds the Challenge from the given decidim_challenges_challenge_id
      #
      # Returns a Decidim::Challenges::Challenge
      def challenge
        @challenge ||= @problem.present? ? Decidim::Challenges::Challenge.find(@problem.challenge.id) : Decidim::Challenges::Challenge.find(@decidim_challenges_challenge_id)
      end

      def author
        Decidim::User.find(author_id)
      end
    end
  end
end
