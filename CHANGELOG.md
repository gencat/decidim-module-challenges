# Changelog
Following Semantic Versioning 2.

## next version:

## Version 0.0.10 (MINOR)
- In show Challenge, hide "Keywords" and "Proposed solutions" when they are empty.
- In show Problem, hide "Keywords" and "Proposed solutions" when they are empty.
- In show Solution, hide "Keywords", "Beneficiaries", "Requeriments" and "Indicators" when they are empty.
- Upgrade module's Ruby to 2.7.5
- Fix: hide Challenges, Problems and Solutions from global search when its Participatory space is not visible

## Version 0.0.9 (PATCH)
- Fix: show solutions only when everything is published

## Version 0.0.8 (MINOR)
- Surveys in Challenges: show survey's answers and exportation.

## Version 0.0.7 (MINOR)
- Truncate description in cards to 100 chars max

## Version 0.0.6 (MINOR)
- Make titles longer

## Version 0.0.5 (PATCH)
- Fix solution detail don't render SDG when the parent is a Challenge.
- Increase Rspec suite timeout to 15 minutes.

## Version 0.0.4 (PATCH)
- Fix solution_m_cell when the parent is a Challenge.
- Enable all new Rubocop cops by default.
- Fix GraphQL api broken since upgrading to Decidim v0.24

## Version 0.0.3 (MINOR)
- Increase minimum Decidim version to 0.24.2
- Update Ruby to 2.7.2
- Override public_url and answer_options_url methods in survey_form_controller for Decidim v0.24 

## Version 0.0.2 (MINOR)
- Settings to hide filters in challenges, problems and solutions (#35)
- Relate solutions with challenges
- Add surveys to Challenges
