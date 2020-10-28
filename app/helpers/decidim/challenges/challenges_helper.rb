# frozen_string_literal: true

module Decidim
  module Challenges
    # Custom helpers, scoped to the challenges engine.
    #
    module ChallengesHelper
      def filter_challenges_state_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new('', t('decidim.challenges.challenges_helper.filter_state_values.all')),
          [
            Decidim::CheckBoxesTreeHelper::TreePoint.new('proposal', t('decidim.challenges.challenges_helper.filter_state_values.proposal')),
            Decidim::CheckBoxesTreeHelper::TreePoint.new('executing', t('decidim.challenges.challenges_helper.filter_state_values.executing')),
            Decidim::CheckBoxesTreeHelper::TreePoint.new('finished', t('decidim.challenges.challenges_helper.filter_state_values.finished'))
          ]
        )
      end
    end
  end
end
