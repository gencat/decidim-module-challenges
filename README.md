# Decidim::Challenges

Articulates the collective action of diverse actors in order to address common and shared challenges and the problems that derive from  them across the territory..

## Usage

Challenges will be available as a Component for a Participatory
Space.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-challenges"
```

And then execute:

```bash
bundle install
bundle exec rails decidim_challenges:install:migrations
bundle exec rails db:migrate
```

### Run tests

Create a dummy app in your application (if not present):

```bash
bin/rails decidim:generate_external_test_app
```

And run tests:

```bash
rspec spec
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
