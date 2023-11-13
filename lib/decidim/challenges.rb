# frozen_string_literal: true

require "decidim/challenges/component"
require "decidim/problems/component"
require "decidim/sdgs/component"
require "decidim/solutions/component"

module Decidim
  # This namespace holds the logic of the `Challenges` component. This component
  # allows users to create challenges in a participatory space.
  module Challenges
    def parsed_attribute(attribute)
      Decidim::ContentProcessor.parse_with_processor(:hashtag, form.send(attribute), current_organization: form.current_organization).rewrite
    end

    def challenge_id
      problem = Decidim::Problems::Problem.find_by(id: form.decidim_problems_problem_id)

      problem&.decidim_challenges_challenge_id.presence
    end
  end
end
