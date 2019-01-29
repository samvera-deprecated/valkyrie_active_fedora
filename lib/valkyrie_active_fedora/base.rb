require 'active_support/descendants_tracker'
# require 'active_fedora/errors'
# require 'active_fedora/log_subscriber'

module ValkyrieActiveFedora
  # This class ties together many of the lower-level modules, and
  # implements something akin to an ActiveRecord-alike interface to
  # fedora. If you want to represent a fedora object in the ruby
  # space, this is the class you want to extend.
  #
  # =The Basics
  #   class Oralhistory < ActiveFedora::Base
  #     property :creator, predicate: RDF::Vocab::DC.creator
  #   end
  #
  # The above example creates a Fedora object with a property named "creator"
  #
  # Attached files defined with +has_subresource+ and iis accessed via the +attached_files+ member hash.
  #
  class Base < ActiveFedora::Base
    def valkyrie_resource
      klass = "Valkyrie::#{self.class.to_s}".constantize
    rescue NameError
      nil
    end

    def attributes_including_linked_ids
      local_attributes = attributes.dup
      reflections.keys.each do |key|
        id_method = "#{key.to_s.singularize}_ids"
        next unless self.respond_to? id_method
        local_attributes.merge!(id_method => self.send(id_method)).with_indifferent_access
      end
      local_attributes
    end
  end

  # ActiveSupport.run_load_hooks(:valkyrie_active_fedora, Base)
end
