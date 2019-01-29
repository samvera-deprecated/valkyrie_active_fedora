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
end
