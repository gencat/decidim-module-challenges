# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # A form object used to create solutions from the admin dashboard.
      #
      class SolutionsForm < Decidim::Form
        include TranslatableAttributes

        mimic :solution

        translatable_attribute :title, String do |field, _locale|
          validates field, length: { in: 5..150 }, if: proc { |resource| resource.send(field).present? }
        end
        translatable_attribute :description, String

        attribute :decidim_problems_problem_id, Integer
        attribute :decidim_challenges_challenge_id, Integer
        attribute :tags, String
        translatable_attribute :objectives, String
        translatable_attribute :indicators, String
        translatable_attribute :beneficiaries, String
        translatable_attribute :requirements, String
        translatable_attribute :financing_type, String

        validates :title, :description, translatable_presence: true
        validates :decidim_challenges_challenge_id, presence: false
        validates :decidim_problems_problem_id, presence: false

        alias organization current_organization

        # Return a problem's list filtered by participatory's space component
        def select_problem_collection
          participatory_space = Decidim::Component.find(current_component.id).participatory_space
          problem_component = Decidim::Component.where(participatory_space: participatory_space).where(manifest_name: "problems")
          Decidim::Problems::Problem.where(component: problem_component).map do |p|
            [translated_attribute(p.title), p.id]
          end
        end

        # Return a challenges's list filtered by participatory's space component
        def select_challenge_collection
          participatory_space = Decidim::Component.find(current_component.id).participatory_space
          challenge_component = Decidim::Component.where(participatory_space: participatory_space).where(manifest_name: "challenges")
          Decidim::Challenges::Challenge.where(component: challenge_component).map do |p|
            [translated_attribute(p.title), p.id]
          end
        end

        # Finds the Problem from the given decidim_problems_problem_id
        #
        # Returns a Decidim::Problems::Problem
        def problem
          @problem ||= decidim_problems_problem_id.present? ? Decidim::Problems::Problem.find(decidim_problems_problem_id) : false
        end

        # Finds the Challenge from the given decidim_challenges_challenge_id
        #
        # Returns a Decidim::Challenges::Challenge
        def challenge
          @challenge ||= @problem.present? ? Decidim::Challenges::Challenge.find(@problem.challenge.id) : false
        end

        def map_model(model); end
      end
    end
  end
end
