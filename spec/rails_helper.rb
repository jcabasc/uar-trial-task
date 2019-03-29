# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
message = 'The Rails environment is running in production mode!'
abort(message) if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
