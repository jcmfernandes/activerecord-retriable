# ActiveRecord::Retriable

Retry your `ActiveRecord` transactions. Inspired by
[Sequel's](http://sequel.jeremyevans.net/) way of doing it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-retriable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord-retriable

## Usage

Retry if `ActiveRecord::TransactionRollbackError` is raised:

```ruby
ActiveRecord::Base.transaction(retry_on: ActiveRecord::TransactionRollbackError) do
  ...
end
```

Retry if `ActiveRecord::TransactionRollbackError` or
`ActiveRecord::LockWaitTimeout` are raised:

```ruby
ActiveRecord::Base.transaction(retry_on: [ActiveRecord::TransactionRollbackError, ActiveRecord::LockWaitTimeout]) do
  ...
end
```

By default we retry once. You can change the default number of retries by
changing:

```ruby
Rails.configuration.active_record.default_transaction_retries
```

Or you can override the default value locally:

```ruby
ActiveRecord::Base.transaction(retry_on: ActiveRecord::TransactionRollbackError
                               num_retries: 3) do
  ...
end
```

To retry indefinitely, set `num_retries:` to `nil`. Be careful when doing that!

To perform an action before retrying, pass an object that responds to `#call` in
`before_retry:`:

```ruby
before_retry = ->(num_retries, exception) do
  puts "retrying transaction for the #{num_retries.ordinalize} time: #{exception}"
end

ActiveRecord::Base.transaction(retry_on: ActiveRecord::TransactionRollbackError
                               before_retry: before_retry) do
  ...
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jcmfernandes/activerecord-retriable. This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [code of
conduct](https://github.com/jcmfernandes/activerecord-retriable/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `ActiveRecord::Retriable` project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/jcmfernandes/activerecord-retriable/blob/master/CODE_OF_CONDUCT.md).

## Maintainer

João Fernandes <joao.fernandes@ist.utl.pt>
