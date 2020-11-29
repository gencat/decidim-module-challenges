# frozen_string_literal: true

module Decidim
  module Sdgs
    # A Sustainable Development Goal
    class Sdg
      SDGS = [
        :no_poverty,
        :zero_hunger,
        :good_health,
        :quality_education,
        :gender_equality,
        :clean_water,
        :clean_energy,
        :decent_work,
        :iiai,
        :reduced_inequalities,
        :sustainable_cities,
        :responsible_consumption,
        :climate_action,
        :life_below_water,
        :life_on_land,
        :pjsi,
        :partnership,
      ].freeze

      # Parameter
      # idxs - Array of Sdgs indexes, between 1 and 17
      def self.codes_from_idxs(idxs)
        idxs.collect do |idx|
          code_from_idx(idx)
        end
      end

      # Parameter
      # idx - The index of the Sdg, between 1 and 17
      def self.code_from_idx(idx)
        SDGS[idx.to_i - 1]
      end
    end
  end
end
