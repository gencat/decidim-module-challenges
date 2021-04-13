# frozen_string_literal: true

class AddSurveyAttributesToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_challenges_challenges, :survey_enabled, :boolean, null: false, default: false
  end
end
