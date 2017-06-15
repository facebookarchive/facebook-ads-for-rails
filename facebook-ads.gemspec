# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "facebook/ads/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "facebook-ads"
  s.version     = Facebook::Ads::VERSION
  s.authors     = ["vslaykovsky"]
  s.email       = ["vslaykovsky@fb.com"]
  s.homepage    = "http://facebook.com"
  s.summary     = "Integration with Facebook Dynamic Product Ads"
  s.description = "Integration with Facebook Dynamic Product Ads"
  s.license     = "https://developers.facebook.com/policy/"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "sqlite3"
end
