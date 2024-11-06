# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Problems
    module Admin
      describe ProblemsForm do
        subject { described_class.from_params(attributes).with_context(current_organization: organization) }

        let(:organization) { create(:organization) }
        let(:scope) { create(:scope, organization: organization) }
        let(:title) do
          {
            en: "Problem title",
            es: "Título problema",
            ca: "Títol problema",
          }
        end
        let(:description) do
          {
            en: "Problem description",
            es: "Descripción problema",
            ca: "Descripció problema",
          }
        end
        let(:challenge) { create(:challenge) }
        let(:tags) { "tag1, tag2, tag3" }
        let(:causes) { "causes" }
        let(:groups_affected) { "groups affected" }
        let(:start_date) { 2.days.from_now.strftime("%d/%m/%Y") }
        let(:end_date) { (2.days.from_now + 4.hours).strftime("%d/%m/%Y") }
        let(:collaborating_entities) { "collaborating_entities" }
        let(:proposing_entities) { "proposing_entities" }
        let(:state) { 2 }
        let(:attributes) do
          {
            "title" => title,
            "description" => description,
            "decidim_challenges_challenge_id" => challenge&.id,
            "tags" => tags,
            "causes" => causes,
            "groups_affected" => groups_affected,
            "state" => state,
            "start_date" => start_date,
            "end_date" => end_date,
            "collaborating_entities" => collaborating_entities,
            "proposing_entities" => proposing_entities,
            "scope" => scope,
          }
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "when default language in title is missing" do
          let(:title) do
            {
              ca: "Títol",
            }
          end

          it { is_expected.not_to be_valid }
        end

        context "when default language in description is missing" do
          let(:description) do
            {
              ca: "Descripció",
            }
          end

          it { is_expected.not_to be_valid }
        end

        context "when challenge is missing" do
          let(:challenge) { nil }

          it { is_expected.not_to be_valid }
        end

        context "when state is missing" do
          let(:state) { nil }

          it { is_expected.not_to be_valid }
        end

        context "when start date is missing" do
          let(:start_date) { nil }

          it { is_expected.not_to be_valid }
        end

        context "when end date is missing" do
          let(:end_date) { nil }

          it { is_expected.not_to be_valid }
        end

        context "when start date is bigger than end date" do
          let(:start_date) { 2.days.from_now }
          let(:end_date) { 1.day.from_now }

          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
