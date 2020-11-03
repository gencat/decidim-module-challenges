# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Challenges
    module Admin
      describe ChallengesForm do
        subject { described_class.from_params(attributes).with_context(current_organization: organization) }

        let(:organization) { create :organization }
        let(:scope) { create :scope, organization: organization }
        let(:title) do
          {
            en: 'Challenge title',
            es: 'Título reto',
            ca: 'Títol repte'
          }
        end
        let(:local_description) do
          {
            en: 'Local description',
            es: 'Descripción local',
            ca: 'Descripció local'
          }
        end
        let(:global_description) do
          {
            en: 'Global description',
            es: 'Descripción global',
            ca: 'Descripció global'
          }
        end
        let(:sdg) { 'sdg' }
        let(:tags) { 'tag1, tag2, tag3' }
        let(:state) { 2 }
        let(:start_date) { 2.days.from_now }
        let(:end_date) { 2.days.from_now + 4.hours }
        let(:collaborating_entities) { 'collaborating_entities' }
        let(:coordinating_entities) { 'coordinating_entities' }
        let(:attributes) do
          {
            'title' => title,
            'local_description' => local_description,
            'global_description' => global_description,
            'sdg' => sdg,
            'tags' => tags,
            'state' => state,
            'start_date' => start_date,
            'end_date' => end_date,
            'collaborating_entities' => collaborating_entities,
            'coordinating_entities' => coordinating_entities,
            'scope' => scope
          }
        end

        context 'when everything is OK' do
          it { is_expected.to be_valid }
        end

        context 'when default language in title is missing' do
          let(:title) do
            {
              ca: 'Títol'
            }
          end

          it { is_expected.to be_invalid }
        end

        context 'when default language in local_description is missing' do
          let(:local_description) do
            {
              ca: 'Descripció'
            }
          end

          it { is_expected.to be_invalid }
        end

        context 'when default language in global_description is missing' do
          let(:global_description) do
            {
              ca: 'Descripció curta'
            }
          end

          it { is_expected.to be_invalid }
        end

        context 'when state is missing' do
          let(:state) { nil }

          it { is_expected.to be_invalid }
        end

        context 'when start date is missing' do
          let(:start_date) { nil }

          it { is_expected.to be_invalid }
        end

        context 'when end date is missing' do
          let(:end_date) { nil }

          it { is_expected.to be_invalid }
        end

        context 'when start date is bigger than end date' do
          let(:start_date) { 2.days.from_now }
          let(:end_date) { 1.days.from_now }

          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
