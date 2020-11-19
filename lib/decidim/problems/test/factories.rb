# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :problems_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :problems).i18n_name }
    manifest_name { :problems }
    participatory_space { create(:participatory_process, :with_steps) }
  end

  factory :problem, traits: [:execution, :finished, :proposal], class: "Decidim::Problems::Problem" do
    title { generate_localized_title }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    state { "execution" }
    causes { "causes" }
    groups_affected { "groups affected" }
    start_date { 1.day.from_now }
    end_date { start_date + 2.months }
    component { build(:component, manifest_name: "problems") }
    challenge { build(:challenge) }
    proposing_entities { [1..5].collect { generate(:name) }.join(", ") }
    collaborating_entities { [1..5].collect { generate(:name) }.join(", ") }
    published_at { Time.current }

    trait :proposal do
      state { "proposal" }
    end

    trait :execution do
      state { "execution" }
    end

    trait :finished do
      state { "finished" }
    end
  end
end
