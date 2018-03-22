# Zlk

Simple wrapper over `ZK` gem for Zookeeper locks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zlk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zlk

## Usage

```ruby
Zlk.config_file = Rails.root.join('config', 'zlk.yml')
Zlk.env = Rails.env

Zlk.create_lock('lock/path').run_exclusively { <your code> }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mainameiz/zlk.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
