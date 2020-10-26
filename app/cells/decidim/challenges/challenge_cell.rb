# frozen_string_literal: true

module Decidim
    module Challenges
      # This cell renders the budget project card for an instance of a project
      # the default size is the Medium Card (:m)
      class ChallengeCell < Decidim::ViewModel
        include Cell::ViewModel::Partial
  
        def show
          cell card_size, model, options
        end
  
        private
  
        def card_size
          "decidim/challenges/challenge_m"
        end
      end
    end
  end
  