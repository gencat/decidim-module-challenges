# Changelog
Following Semantic Versioning 2.

## next version:

## Version 0.3.3 (PATCH)
- Fix update challenge with a card image

## Version 0.3.2 (PATCH)
- Fix card image validation in Challenges Form.

## Version 0.3.1 (PATCH)
- Fix search collection by current component in public controllers.

## Version 0.3.0 (MINOR)
- Increase minimum Decidim version to 0.27.4
- Refactor scope, category and SDG filters with Ransack
- Fix when save challenge in CRUD solutions when there is a associated problem.

## Version 0.2.1 (MINOR)
- Upgrade module's Ruby to 3.0.6

## Version 0.2.0 (MINOR)
- Increase minimum Decidim version to 0.26.2

## Version 0.1.0 (MINOR)
- Increase minimum Decidim version to 0.25.2

## Version 0.0.15 (PATCH)
- Check if the file has any errors in format in the Challenges surveys.

## Version 0.0.14 (PATCH)
- Add missing translations in :es and :en.

## Version 0.0.13 (PATCH)
- Fix empty exportations in Challenges surveys.

## Version 0.0.12 (MINOR)
- Add card images to Challenges.

## Version 0.0.11 (MINOR)
- Fix order filter in Challenges, Solutions and Problems.

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
