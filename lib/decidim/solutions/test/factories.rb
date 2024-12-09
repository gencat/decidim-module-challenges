# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :solutions_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :solutions).i18n_name }
    manifest_name { :solutions }
    participatory_space { association(:participatory_process, :with_steps) }
  end

  factory :solution, class: "Decidim::Solutions::Solution" do
    title { generate_localized_title }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    component { association(:solutions_component) }
    author { association(:user, :admin) }
    problem { association(:problem) }
    challenge { association(:challenge) }

    tags { Decidim::Faker::Localized.localized { [1..5].collect { generate(:name) }.join(", ") } }
    indicators { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    objectives { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    beneficiaries { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    financing_type { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    requirements { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    published_at { Time.current }
  end
end
