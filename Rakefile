require 'rake/clean'
require 'bundler'

Bundler::GemHelper.install_tasks

# load rake tasks defined in lib/tasks that are not loaded in lib/valkyrie_active_fedora.rb
load "lib/tasks/valkyrie_active_fedora_dev.rake"

CLEAN.include %w(**/.DS_Store tmp *.log *.orig *.tmp **/*~)

desc 'setup jetty and run tests'
task ci: ['valkyrie_active_fedora:ci']
desc 'run tests'
task spec: ['valkyrie_active_fedora:rubocop', 'valkyrie_active_fedora:rspec']
task rcov: ['valkyrie_active_fedora:rcov']

task default: [:ci]
