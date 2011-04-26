source 'http://rubygems.org'

gem 'rails'
gem "jquery-rails"
gem "simple_form"

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
end

platforms :ruby, :mswin do
  gem 'pg'
end


group :test, :development do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'timecop'
  gem 'factory_girl_rails'
end
