require 'active_support/descendants_tracker'

module ValkyrieActiveFedora
  # This class extends ActiveFedora::Base to add in methods that allow
  # an instance of the class to be converted to a Valkyrie::Resource.
  #
  # =The Basics
  #   class Oralhistory < ValkyrieActiveFedora::Base
  #     property :creator, predicate: RDF::Vocab::DC.creator
  #   end
  class Base < ActiveFedora::Base
    def valkyrie_resource
      "Valkyrie::#{self.class}".constantize
    rescue NameError
      nil
    end

    def attributes_including_linked_ids
      local_attributes = attributes.dup
      reflections.each_key do |key|
        id_method = "#{key.to_s.singularize}_ids"
        next unless respond_to? id_method
        local_attributes.merge!(id_method => send(id_method)).with_indifferent_access
      end
      local_attributes
    end
  end
end
