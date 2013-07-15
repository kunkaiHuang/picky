# encoding: utf-8
#
require 'spec_helper'
require 'ostruct'

describe "OR token" do

  it 'handles simple cases' do
    index = Picky::Index.new :or do
      category :text
    end

    thing = OpenStruct.new id: 1, text: "hello ohai"
    other = OpenStruct.new id: 2, text: "hello ohai kthxbye"

    index.add thing
    index.add other

    try = Picky::Search.new index
    
    # With or, or |.
    #
    try.search("hello text:ohai|text:kthxbye").ids.should == [2, 1]
    try.search("hello text:ohai|kthxbye").ids.should == [2, 1]
    try.search("hello ohai|text:kthxbye").ids.should == [2, 1]
    try.search("hello ohai|kthxbye").ids.should == [2, 1]
  end
  
  it 'handles more complex cases' do
    index = Picky::Index.new :or do
      category :text1
      category :text2
    end

    thing = OpenStruct.new id: 1, text1: "hello world", text2: "ohai kthxbye"
    other = OpenStruct.new id: 2, text1: "hello something else", text2: "to be or not to be"

    index.add thing
    index.add other

    try = Picky::Search.new index
    
    # With or, or |.
    #
    # Note that the order is changed.
    #
    try.search("hello ohai|not").ids.should == [1, 2]
    try.search("hello not|ohai").ids.should == [2, 1]
    try.search("hello ohai|kthxbye").ids.should == [1]
    try.search("hello nonexisting|not").ids.should == [2]
    try.search("hello nonexisting|alsononexisting").ids.should == []
  end
  
  it 'handles even more complex cases' do
    index = Picky::Index.new :or do
      category :text, similarity: Picky::Similarity::DoubleMetaphone.new(3)
    end

    thing = OpenStruct.new id: 1, text: "hello ohai tester 3"
    other = OpenStruct.new id: 2, text: "hello ohai kthxbye"

    index.add thing
    index.add other

    try = Picky::Search.new index
    
    # With or, or |.
    #
    # TODO Similarity, partial, and range.
    #
    # try.search("text:testor~|text:kthxbye hello").ids.should == [2, 1]
    # try.search("text:test*|kthxbye hello").ids.should == [2, 1]
    # try.search("text:1-5|kthxbye hello").ids.should == [2, 1]
    try.search("hello text,other:ohai|text:kthxbye").ids.should == [2, 1]
    try.search("hello something,other:ohai|kthxbye").ids.should == [2, 1]
  end

end