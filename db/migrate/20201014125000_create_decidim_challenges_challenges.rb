class CreateDecidimChallengesChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_challenges_challenges do |t|
      t.string :title
      t.string :territory_description
      t.string :global_description
      t.string :tags
      t.string :ods
      t.integer :territory_id
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.string :coord_entity
      t.string :col_entity

      t.timestamps
    end
  end
end
