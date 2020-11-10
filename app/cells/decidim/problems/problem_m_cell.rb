# frozen_string_literal: true

module Decidim
    module Problems
        # This cell renders the Medium (:m) project card
        # for an given instance of a Project
        class ProblemMCell < Decidim::CardMCell
            include ActiveSupport::NumberHelper
            include Decidim::Problems::ProblemHelper

            private

            def resource_icon
                icon "problems", class: "icon--big"
            end
        end
    end
end
