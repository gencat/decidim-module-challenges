# frozen_string_literal: true

class AddQuestionnaireToExistingChallenges < ActiveRecord::Migration[5.2]
  def change
    Decidim::Challenges::Challenge.transaction do
      Decidim::Challenges::Challenge.find_each do |challenge|
        if challenge.component.present? && challenge.questionnaire.blank?
          challenge.update!(
            questionnaire: Decidim::Forms::Questionnaire.new
          )
        end
      end
    end
  end
end
