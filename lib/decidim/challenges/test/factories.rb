# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :challenges_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :challenges).i18n_name }
    manifest_name { :challenges }
    participatory_space { create(:participatory_process, :with_steps) }
    scope
  end

  factory :challenge, traits: [:proposal, :execution, :finished], class: "Decidim::Challenges::Challenge" do
    title { generate_localized_title }
    local_description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    global_description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    state { "execution" }
    start_date { 1.day.from_now }
    end_date { start_date + 2.months }
    component { build(:component, manifest_name: "challenges") }
    coordinating_entities { [1..5].collect { generate(:name) }.join(", ") }
    collaborating_entities { [1..5].collect { generate(:name) }.join(", ") }
    published_at { Time.current }

    trait :execution do
      state { "execution" }
    end

    trait :proposal do
      state { "proposal" }
    end

    trait :finished do
      state { "finished" }
    end
  end
end
