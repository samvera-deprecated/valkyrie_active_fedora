# frozen_string_literal: true

module ValkyrieActiveFedora
  # we really want a class var here. maybe we could use a singleton instead?
  # rubocop:disable Style/ClassVars
  class ResourceFactory
    class ResourceClassCache
      attr_reader :cache

      def initialize
        @cache = {}
      end

      def fetch(key)
        @cache.fetch(key) do
          @cache[key] = yield
        end
      end
    end

    @@resource_class_cache = ResourceClassCache.new

    attr_accessor :active_fedora_object

    def initialize(active_fedora_object:)
      self.active_fedora_object = active_fedora_object
    end

    def self.for(active_fedora_object)
      new(active_fedora_object: active_fedora_object).build
    end

    def build
      klass = @@resource_class_cache.fetch(active_fedora_object) do
        # we need a local binding to the object for use in the class scope below
        active_fedora_local = active_fedora_object

        Class.new(::Valkyrie::Resource) do
          active_fedora_local.send(:properties).each_key do |property_name|
            attribute property_name.to_sym, ::Valkyrie::Types::String
          end
        end
      end

      klass.new(id: active_fedora_object.id, **active_fedora_object.attributes.symbolize_keys)
    end

    # private
    #
    #   def attributes_including_linked_ids
    #     local_attributes = attributes.dup
    #     reflections.keys.each do |key|
    #       id_method = "#{key.to_s.singularize}_ids"
    #       next unless self.respond_to? id_method
    #       local_attributes.merge!(id_method => self.send(id_method)).with_indifferent_access
    #     end
    #     local_attributes
    #   end
  end
  # rubocop:enable Style/ClassVars
end
