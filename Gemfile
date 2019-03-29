source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'jsonapi-resources', '~> 0.9.5'
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.7'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'ordinare', '~> 0.4.0'
  gem 'rubocop', '~> 0.63.1', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot_rails', '~> 5.0'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.3'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
