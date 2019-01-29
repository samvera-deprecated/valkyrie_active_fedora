require 'rails/generators'

module ValkyrieActiveFedora
  class ConfigGenerator < Rails::Generators::Base
    def generate_configs
      generate('valkyrie_active_fedora:config:fedora')
      generate('valkyrie_active_fedora:config:solr')
    end
  end
end
