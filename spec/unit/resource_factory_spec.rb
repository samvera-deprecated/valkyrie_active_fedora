# frozen_string_literal: true
require 'spec_helper'

RSpec.describe ValkyrieActiveFedora::ResourceFactory do
  subject(:factory) { described_class.new(active_fedora_object: book) }

  class BookWithPages < ValkyrieActiveFedora::Base
    # has_many :pages
    property :title, predicate: ::RDF::Vocab::DC.title
    property :contributor, predicate: ::RDF::Vocab::DC.contributor
    property :description, predicate: ::RDF::Vocab::DC.description
  end
  # class Page < ValkyrieActiveFedora::Base
  #   belongs_to :book_with_pages, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf
  # end

  let(:id)          { 'moomin123' }
  let(:book)        { BookWithPages.new(id: id, **attributes) }
  # let(:page1)       { Page.new(id: 'pg1') }
  # let(:page2)       { Page.new(id: 'pg2') }

  let(:attributes) do
    {
      title: ['fake title'],
      contributor: ['user1'],
      description: ['a description']
      # description: ['a description'],
      # pages: [page1, page2]
    }
  end

  # TODO: extract to Valkyrie?
  define :have_a_valkyrie_id_of do |expected_id_str|
    match do |valkyrie_resource|
      expect(valkyrie_resource.id).to be_a Valkyrie::ID
      valkyrie_resource.id.id == expected_id_str
    end
  end

  describe '.for' do
    it 'returns a Valkyrie::Resource' do
      expect(described_class.for(book)).to be_a Valkyrie::Resource
    end
  end

  describe '#build' do
    it 'returns a Valkyrie::Resource' do
      expect(factory.build).to be_a Valkyrie::Resource
    end

    it 'has the id of the active_fedora_object' do
      expect(factory.build).to have_a_valkyrie_id_of book.id
    end

    it 'has attributes matching the active_fedora_object' do
      expect(factory.build)
        .to have_attributes title: book.title,
                            contributor: book.contributor,
                            description: book.description
      #                      description: book.description,
      #                      page_ids: [page1.id, page2.id]
    end
  end
end
