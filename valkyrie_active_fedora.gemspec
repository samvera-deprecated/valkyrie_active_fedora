# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'valkyrie_active_fedora/version'

Gem::Specification.new do |s|
  s.name          = 'valkyrie_active_fedora'
  s.version       = ValkyrieActiveFedora::VERSION
  s.authors       = ['E. Lynette Rayle']
  s.email         = ['elr37@cornell.edu']
  s.homepage      = 'http://github.com/samvera-labs/valkyrie_active_fedora'
  s.summary       = 'A rails engine to extend ActiveFedora gem to play nicely with Valkyrie data mapper gem'
  s.description   = 'A rails engine to extend ActiveFedora gem to play nicely with Valkyrie data mapper gem'
  s.license       = 'Apache-2.0'
  s.required_ruby_version = '~> 2.0'

  # Note: rails does not follow sem-ver conventions, it's
  # minor version releases can include breaking changes; see
  # http://guides.rubyonrails.org/maintenance_policy.html
  s.add_dependency 'rails', '~> 5.0' # Keep in sync with version supported by Hyrax

  s.add_development_dependency 'active-fedora'
  s.add_development_dependency 'valkyrie'

  # s.add_development_dependency 'bixby', '~> 1.0.0' # rubocop styleguide
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'solr_wrapper', '~> 2.0'
  s.add_development_dependency 'fcrepo_wrapper', '~> 0.2'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'equivalent-xml'
  s.add_development_dependency 'simplecov', '~> 0.8'
  s.add_development_dependency 'rubocop', '~> 0.56.0'
  s.add_development_dependency 'rubocop-rspec', '~> 1.12.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [
    'LICENSE',
    'README.md'
  ]
  s.require_paths = ['lib']
end
