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

    it 'returns nil when the Valkyrie version of the class is NOT defined' do
      expect(foo_history.valkyrie_resource).to eq nil
    end
  end

  describe '#attributes_including_linked_ids' do
    context 'for has_many and belongs_to relationships' do
      before :all do
        class Library < ValkyrieActiveFedora::Base
          has_many :books
        end
        class Book < ValkyrieActiveFedora::Base
          belongs_to :library, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf
        end
      end

      after :all do
        Object.send(:remove_const, :Library)
        Object.send(:remove_const, :Book)
      end

      let(:library1) { Library.create(id: 'lib1', books: [book1]) }
      # let(:book1) { Book.create(id: 'bk1', library: library1) }
      let(:book1) { Book.create(id: 'bk1') }

      before do
        book1.library = library1
        book1.save
      end

      it "inserts ids of child objects into parent's attributes" do
        expected_results = { 'id' => 'lib1', 'book_ids' => ['bk1'] }
        # expect(library1.attributes_including_linked_ids).to eq expected_results
        expect(library1.reload.attributes_including_linked_ids).to eq expected_results
      end

      it "inserts ids of parent objects into child's attributes" do
        expected_results = { 'id' => 'bk1', 'library_id' => 'lib1' }
        expect(book1.reload.attributes_including_linked_ids).to eq expected_results
      end
    end
  end
end
