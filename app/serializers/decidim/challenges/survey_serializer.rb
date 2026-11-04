# frozen_string_literal: true

module Decidim
  module Challenges
    class SurveySerializer < Decidim::Exporters::Serializer
      include Decidim::TranslationsHelper
      # Serializes a registration
      def serialize
        {
          id: resource.id,
          author: {
            name: resource.author.name,
            email: resource.author.email,
          },
          survey_form_answers: serialize_responses,
        }
      end

      private

      def serialize_responses
        questions = resource.challenge.questionnaire.questions
        responses = resource.challenge.questionnaire.responses.where(user: resource.author)
        questions.each_with_index.inject({}) do |serialized, (question, idx)|
          response = responses.find_by(question:)
          serialized.update("#{idx + 1}. #{translated_attribute(question.body)}" => normalize_body(response))
        end
      end

      def normalize_body(response)
        return "" unless response

        response.body || response.choices.pluck(:body)
      end
    end
  end
end
