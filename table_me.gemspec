$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "table_me/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "table_me"
  s.version     = TableMe::VERSION
  s.authors     = ["Adam Rensel"]
  s.email       = ["adamrensel@gmail.com"]
  s.homepage    = "https://github.com/renz45/table_me"
  s.summary     = "Widget table gem for Rails 3.1.3+"
  s.description = "Widget table gem for Rails 3.1.3+"

  s.files = Dir["{app,config,db,lib,table_me}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.1.3"
  # s.add_dependency "rails", "~> 3.2.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "pry"
end
