# Capistrano::Resque::Pool

Capistrano integration for `resque-pool`.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-resque-pool'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install capistrano-resque-pool

## Usage

Start all the workers and queus.

    bundle exec cap production resque:pool:start

Gracefully shut down workers and shutdown the manager after all workers are done.

    bundle exec cap production resque:pool:stop

Gracefully shut down workers and immediately shutdown manager.

    bundle exec cap production resque:pool:stop_immediately

Reload the config file, reload logfiles, restart all workers.

    bundle exec cap production resque:pool:restart

Gracefully shut down workers, Gracefully shut down manager, start a new manager and it's workers

    bundle exec cap production resque:pool:full_restart


## Contributing

1. Fork it ( https://github.com/[my-github-username]/capistrano-resque-pool/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
