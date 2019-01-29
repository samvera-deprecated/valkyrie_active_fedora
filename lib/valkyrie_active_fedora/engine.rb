# frozen_string_literal: true
module ValkyrieActiveFedora
  class Engine < ::Rails::Engine
    isolate_namespace ValkyrieActiveFedora

    require 'valkyrie_active_fedora'

    # def self.engine_mount
    #   ValkyrieActiveFedora::Engine.routes.find_script_name({})
    # end
  end
end
