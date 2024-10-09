# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Solutions
    describe SolutionsForm do
      subject { described_class.from_params(attributes).with_context(current_organization: organization) }

      let(:organization) { create :organization }
      let(:scope) { create :scope, organization: organization }
      let(:current_user) { create :user, :confirmed, organization: organization }
      let(:title) { "Títol solució" }
      let(:description) { "Descripció solució" }
      let(:challenge) { create :challenge }
      let(:project_status) { "in_progress" }
      let(:project_url) { "www.example.org" }
      let(:coordinating_entity) { "www.example.org" }
      let(:uploaded_files) { [] }
      let(:attributes) do
        {
          "title" => title,
          "description" => description,
          "author_id" => current_user.id,
          "decidim_problems_problem_id" => nil,
          "decidim_challenges_challenge_id" => challenge&.id,
          "project_status" => project_status,
          "project_url" => project_url,
          "coordinating_entity" => coordinating_entity,
          "add_documents" => uploaded_files,
        }
      end

      context "when everything is OK" do
        it { is_expected.to be_valid }
      end

      context "when title is missing" do
        let(:title) { nil }

        it { is_expected.to be_invalid }
      end

      context "when description is missing" do
        let(:description) { nil }

        it { is_expected.to be_invalid }
      end

      context "when problem is missing but there is a challenge" do
        it { is_expected.to be_valid }
      end

      context "when challenge is missing" do
        let(:challenge) { nil }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
