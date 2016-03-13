<<<<<<< HEAD
# OptClient

Gem for use api https://github.com/stopanko/test_api
API server also running on https://opttestapi.herokuapp.com/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opt_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opt_client

## Usage

Use `require 'opt_client'` if gem not required with bundler.

###Init api instrument
```ruby
instrument = OptClient.init_api
```
or with options
```ruby
instrument = OptClient.init_api(version: 'v1', host: 'https://opttestapi.herokuapp.com/')
```


####defult options
    version: 'v1'
    host: 'http://localhost:4567'


for use api in locale machine run https://github.com/stopanko/test_api server with `rackup -E test` option and use `http://localhost:9292` host

###Client Model
```ruby
model_options = {email: 'newemail@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'sms',
                            company_name: '3444'}
```
####validations
-- channel -> sms, email, sms+email <br>
-- permission_type -> one-time, permanent <br>
-- only one chanel_type for one company_name <br>

##Methods

`instrument.connected?` return `true` or `false`

----
```ruby
client = instrument.create(model_options)
```

return `Client` object if created and `{error: client.errors.full_messages.join(', '), status: :error}.to_json` if error

----

```ruby
client = instrument.update(model_options)
```
<b>Need contains object id</b>

return updated `Client` object if success or `{error: "Not updated. ID: #{params[:client][:id]}", status: :error}.to_json` if error

----

```ruby
instrument.destroy(id)
```

return `true` if success and `{error: "Record Not found with id #{params[:client][:id]}", status: :error}.to_json` if error

----

###Client model methods
You can get client model from api

```ruby
client = instrument.create(model_options)
client = instrument.update(model_options)
```
or create by yourself

```ruby
client = Client.new(model_options, instrument)
```
<b> For use model api methods you need set an instrument instance</b> <br>
<b> All methods return error if instrument option empty</b>

----

```ruby
client.create
```
use instrument create method

----

```ruby
client.email = 'new@email.com'
client.update
```
or

```ruby
client.update(email: 'new@email.com')
```
update client model
----

```ruby
client.email = 'new@email.com'
client.save
```
Use create method if client.id empty or update if client.id present

----


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/opt_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

=======
# opt_client
api gem for test_api repo
>>>>>>> 97cb6bd1e4d7055e88e8c26bb51ef4321cfe6a21
