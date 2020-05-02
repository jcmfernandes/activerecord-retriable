# frozen_string_literal: true

require 'bundler/setup'

require 'fileutils'
require 'rails'
require 'active_record'
require 'active_record/railtie'
require 'pry'

class FakeApplication < Rails::Application; end
Rails.application = FakeApplication

FileUtils.makedirs('log')
ActiveRecord::Base.logger = Logger.new('log/test.log')
ActiveRecord::Base.logger.level = Logger::DEBUG
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Migration.verbose = false

RSpec.configure do |config|
  config.order = 'random'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.before(:suite) do
    FileUtils.rm_f('spec/db.sqlite3')
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'spec/db.sqlite3')
  end

  config.after(:suite) do
    ActiveRecord::Base.connection_pool.disconnect!
    FileUtils.rm_f('spec/db.sqlite3')
  end
end
