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
      "Valkyrie::#{self.class}".constantize.new
    rescue NameError
      nil
    end

    def attributes_including_linked_ids
      local_attributes = attributes.dup
      linked_id_keys.each do |id_method|
        local_attributes.merge!(id_method => send(id_method)).with_indifferent_access
      end
      local_attributes
    end

    def linked_id_keys
      @linked_id_keys ||= reflections.keys.map do |key|
        id_method = "#{key.to_s.singularize}_ids"
        id_method if respond_to? id_method
      end.compact
    end
  end
end
