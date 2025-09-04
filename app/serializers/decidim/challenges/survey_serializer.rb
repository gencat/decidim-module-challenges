# frozen_string_literal: true

module Decidim
  module Challenges
    class SurveySerializer < Decidim::Exporters::Serializer
      include Decidim::TranslationsHelper
      # Serializes a registration
      def serialize
        {
          id: resource.id,
          user: {
            name: resource.author.name,
            email: resource.author.email,
          },
          survey_form_answers: serialize_answers,
        }
      end

      private

      def serialize_answers
        questions = resource.challenge.questionnaire.questions
        answers = resource.challenge.questionnaire.answers.where(user: resource.author)
        questions.each_with_index.inject({}) do |serialized, (question, idx)|
          answer = answers.find_by(question:)
          serialized.update("#{idx + 1}. #{translated_attribute(question.body)}" => normalize_body(answer))
        end
      end

      def normalize_body(answer)
        return "" unless answer

        answer.body || answer.choices.pluck(:body)
      end
    end
  end
end
