# frozen_string_literal: true

require 'decidim/core/test/factories'

FactoryBot.define do
  factory :problems_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :problems).i18n_name }
    manifest_name { :problems }
    participatory_space { create(:participatory_process, :with_steps) }
    scope
  end

  factory :problem, class: 'Decidim::Problems::Problem' do
    title { generate_localized_title }
    description { Decidim::Faker::Localized.wrapped('<p>', '</p>') { generate_localized_title } }
    state { 'executing' }
    start_date { 1.day.from_now }
    end_date { start_date + 2.months }
    component { build(:component, manifest_name: 'problems') }
    proposing_entities { [1..5].collect { generate(:name) }.join(', ') }
    collaborating_entities { [1..5].collect { generate(:name) }.join(', ') }
    published_at { Time.current }

    trait :finished do
      state { 'finished' }
    end

    trait :proposal do
      state { 'proposal' }
    end
  end
end
