require 'helper'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/models/name')) 

class TestTaxonifiName < Test::Unit::TestCase

  def test_truth
    assert(true)
  end

  def test_new_name
    assert n = Taxonifi::Model::Name.new() 
  end

  def test_that_name_has_a_name
    n = Taxonifi::Model::Name.new() 
    assert n.respond_to?(:name)
  end

  def test_that_name_has_an_id
    n = Taxonifi::Model::Name.new() 
    assert n.respond_to?(:id)
  end

  def test_that_name_has_a_parent
    n = Taxonifi::Model::Name.new() 
    assert n.respond_to?(:parent) 
  end

  def test_that_name_has_a_rank
    n = Taxonifi::Model::Name.new() 
    assert n.respond_to?(:rank) 
  end
 
  def test_that_name_has_an_author
    n = Taxonifi::Model::Name.new() 
    assert n.respond_to?(:author) 
  end
  
  def test_that_name_has_a_year
    n = Taxonifi::Model::Name.new() 
    assert n.respond_to?(:year) 
  end

  def test_that_name_returns_false_with_bad_rank
    n = Taxonifi::Model::Name.new() 
    assert_raise Taxonifi::NameError do
      n.rank = "FOO"
    end 
  end

  def test_that_name_allows_legal_rank
    n = Taxonifi::Model::Name.new() 
    assert n.rank = "genus"
  end

  def test_that_name_rank_is_case_insensitive
    n = Taxonifi::Model::Name.new() 
    assert n.rank = "Genus"
    assert n.rank = "GENUS"
  end

  def test_that_rank_is_required_before_parent
    n = Taxonifi::Model::Name.new() 
    assert_raise Taxonifi::NameError do
      n.parent = Taxonifi::Model::Name.new() 
    end
  end

  def test_that_parent_is_a_taxonifi_name
    n = Taxonifi::Model::Name.new() 
    n.rank = "genus" # avoid that raise
    assert_raise Taxonifi::NameError do
      n.parent = "foo"
    end
  end

 def test_that_rank_can_be_set
    n = Taxonifi::Model::Name.new() 
    n.rank = "family"
    assert_equal "family", n.rank
  end


  def test_that_parent_is_higher_rank_than_child
    n = Taxonifi::Model::Name.new() 
    n.rank = "genus"
    p = Taxonifi::Model::Name.new() 
    p.rank = "species"
    assert_raise Taxonifi::NameError do
      n.parent = p
    end
  end

  def test_that_iczn_family_ends_in_idae
    n = Taxonifi::Model::IcznName.new
    assert_raise Taxonifi::NameError do
      n.rank = "family"
      n.name = "Foo"
    end
  end

  def test_that_iczn_subfamily_ends_in_inae
    n = Taxonifi::Model::IcznName.new
    assert_raise Taxonifi::NameError do
      n.rank = "subfamily"
      n.name = "Foo"
    end
  end

  def test_that_iczn_tribe_ends_in_ini
    n = Taxonifi::Model::IcznName.new
    assert_raise Taxonifi::NameError do
      n.rank = "tribe"
      n.name = "Foo"
    end
  end

  def test_that_iczn_subtribe_ends_in_ina
    n = Taxonifi::Model::IcznName.new
    assert_raise Taxonifi::NameError do
      n.rank = "subtribe"
      n.name = "Foo"
    end

    assert n.name = "Fooina"
  end


  def test_that_parent_can_be_set
    n = Taxonifi::Model::Name.new() 
    n.rank = "genus"
    p = Taxonifi::Model::Name.new() 
    p.rank = "species"
    assert p.parent = n
    assert_equal "genus", p.parent.rank
  end

  def test_that_attributes_can_be_assigned_on_new
    n0 = Taxonifi::Model::Name.new(:name => "Baridae", :rank => "Family")
    n = Taxonifi::Model::Name.new(:name => "Foo", :rank => "Genus", :author => "Frank", :year => 2020, :parent => n0)
  
    assert_equal "Foo", n.name
    assert_equal "genus", n.rank
    assert_equal 2020, n.year
    assert_equal "Frank", n.author
    assert_equal n0, n.parent

  end




end
