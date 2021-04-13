# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This class holds a Form to update challenges surveys from Decidim's admin panel.
      class ChallengeSurveysForm < Decidim::Form
        mimic :challenge

        attribute :survey_enabled, Boolean

        # We need this method to ensure the form object will always have an ID,
        # and thus its `to_param` method will always return a significant value.
        # If we remove this method, get an error onn the `update` action and try
        # to resubmit the form, the form will not hold an ID, so the `to_param`
        # method will return an empty string and Rails will treat this as a
        # `create` action, thus raising an error since this action is not defined
        # for the controller we're using.
        #
        # TL;DR: if you remove this method, we'll get errors, so don't.
        def id
          return super if super.present?

          challenge.id
        end

        private

        def challenge
          @challenge ||= context[:challenge]
        end
      end
    end
  end
end
