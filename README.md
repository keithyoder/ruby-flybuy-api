# Ruby::Flybuy::Api

This gem provides access to the Flybuy REST API.  Documentation for this API can be found [here](https://www.radiusnetworks.com/developers/flybuy/#/?id=flybuy-developer-documentation)

This is a work-in-progress.  Not all API funcionality is currently available in this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flybuy'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install flybuy

## Usage

Initialize the gem with your API token:

```ruby
Flybuy.token=[YOUR_TOKEN]
```

### Sites

#### List of sites

```ruby
Flybuy::Site::all
```

#### Create site

These are the required attributes.  You can send any of the other attributes listed in the [documentation](https://www.radiusnetworks.com/developers/flybuy/#/api/v1/sites?id=create-a-site).

```ruby
Flybuy::Site.create(
  {
    project_id: 100,
    name: 'My Site',
    partner_identifier: '1234',
    full_address: '821 Hillcrest Lane, Elsinore, CA 92330',
    phone: '951-245-1835',
    latitude: 44.574352,
    longitude: -81.193817,
    timezone: 'America/Los_Angeles',
  }
)
```

#### Update site

```ruby
Flybuy::Site.update(
  id: 2945,
  attributes: {
    name: 'My Site',
  }
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby-flybuy-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/ruby-flybuy-api/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
