# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :challenges_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :challenges).i18n_name }
    manifest_name { :challenges }
    participatory_space { create(:participatory_process, :with_steps) }

    trait :with_card_image_allowed do
      settings do
        {
          allow_card_image: true,
        }
      end
    end
  end

  factory :challenge, traits: [:proposal, :execution, :finished], class: "Decidim::Challenges::Challenge" do
    title { generate_localized_title }
    local_description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    global_description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    tags { Decidim::Faker::Localized.localized { [1..5].collect { generate(:name) }.join(", ") } }
    state { "execution" }
    start_date { 1.day.from_now }
    end_date { start_date + 2.months }
    component { build(:challenges_component) }
    coordinating_entities { [1..5].collect { generate(:name) }.join(", ") }
    collaborating_entities { [1..5].collect { generate(:name) }.join(", ") }
    published_at { Time.current }
    questionnaire { build(:questionnaire) }

    trait :proposal do
      state { 0 }
    end

    trait :execution do
      state { 1 }
    end

    trait :finished do
      state { 2 }
    end

    trait :with_survey_enabled do
      survey_enabled { true }
    end

    trait :with_card_image do
      card_image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
    end
  end

  factory :survey, class: "Decidim::Challenges::Survey" do
    challenge
    user
  end
end
