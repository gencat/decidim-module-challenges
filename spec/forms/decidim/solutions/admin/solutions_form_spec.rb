# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Solutions
    module Admin
      describe SolutionsForm do
        subject { described_class.from_params(attributes).with_context(current_organization: organization) }

        let(:organization) { create :organization }
        let(:scope) { create :scope, organization: organization }
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
        let(:challenge) { create :challenge }
        let(:problem) { create :problem, challenge: challenge }
        let(:tags) { "tag1, tag2, tag3" }
        let(:objectives) do
          {
            en: "Solution's objectives",
            es: "Objetivo de solución",
            ca: "Objectius de solució",
          }
        end
        let(:indicators) do
          {
            en: "Solution's indicators",
            es: "Indicadores de solución",
            ca: "indicadors de solució",
          }
        end
        let(:beneficiaries) do
          {
            en: "Solution's beneficiaries",
            es: "Benficiarios de solución",
            ca: "Beneficiaris de solució",
          }
        end
        let(:financing_type) do
          {
            en: "Solution's fincing type",
            es: "Tipo financiamiento de solución",
            ca: "Tipus de finançament de solució",
          }
        end
        let(:requirements) do
          {
            en: "Solution's requeriments",
            es: "Requisitos de solución",
            ca: "Requisits de solució",
          }
        end
        let(:attributes) do
          {
            "title" => title,
            "description" => description,
            "decidim_problems_problem_id" => problem&.id,
            "tags" => tags,
            "objectives" => objectives,
            "indicators" => indicators,
            "beneficiaries" => beneficiaries,
            "financing_type" => financing_type,
            "requirements" => requirements,
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

          it { is_expected.to be_invalid }
        end

        context "when default language in description is missing" do
          let(:description) do
            {
              ca: "Descripció",
            }
          end

          it { is_expected.to be_invalid }
        end

        context "when problem is missing" do
          let(:problem) { nil }

          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
