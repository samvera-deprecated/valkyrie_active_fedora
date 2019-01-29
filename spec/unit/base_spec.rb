require 'spec_helper'

describe ValkyrieActiveFedora::Base do
  describe '#valkyrie_resource' do
    let(:foo_history) { FooHistory.new }
    before do
      class FooHistory < ValkyrieActiveFedora::Base
        type ::RDF::URI.new('http://example.com/foo')
        property :title, predicate: ::RDF::Vocab::DC.title
      end
    end
    after do
      Object.send(:remove_const, :FooHistory)
    end

    context 'when the Valkyrie version of the class is defined' do
      before do
        module Valkyrie
          class FooHistory < Valkyrie::Resource
            attribute :id, Valkyrie::Types::ID.optional
          end
        end
      end
      after do
        Valkyrie.send(:remove_const, :FooHistory)
      end
      it 'returns the Valkyrie class' do
        expect(foo_history.valkyrie_resource).to eq Valkyrie::FooHistory
      end
    end

    it 'should return nil when the Valkyrie version of the class is NOT defined' do
      expect(foo_history.valkyrie_resource).to eq nil
    end
  end

  describe '#attributes_including_linked_ids' do
    let(:book) { Book.new(id: 'book_1', pages: [page]) }
    let(:page) { Page.new(id: 'page_1') }

    before do
      class Book < ValkyrieActiveFedora::Base
        has_many :pages, inverse_of: :created # predicate: ::RDF::Vocab::DC.created
      end

      class Page < ValkyrieActiveFedora::Base
        has_and_belongs_to_many :created, predicate: ::RDF::Vocab::DC.created, class_name: 'Book'
      end
    end

    after do
      Object.send(:remove_const, :Book)
      Object.send(:remove_const, :Page)
    end

    it 'does something' do
byebug
      expected_results = book.attributes_including_linked_ids
      expect(expected_results).to eq true
      # expect(foo_history.attributes_including_linked_ids).to eq true
    end

    # local_attributes = attributes.dup
    # reflections.keys.each do |key|
    #   id_method = "#{key.to_s.singularize}_ids"
    #   next unless self.respond_to? id_method
    #   local_attributes.merge!(id_method => self.send(id_method)).with_indifferent_access
    # end
    # local_attributes
  end

end
