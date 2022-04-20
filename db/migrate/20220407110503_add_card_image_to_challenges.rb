# frozen_string_literal: true

class AddCardImageToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_challenges_challenges, :card_image, :string
  end
end
