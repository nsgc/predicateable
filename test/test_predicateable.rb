# frozen_string_literal: true

require_relative "test_helper"

require "predicateable"

class User
  include Predicateable

  attr_reader :age, :account_type, :role

  predicate :age_range, [:young, :middle, :old]
  predicate :account_type, [:guest, :member, :admin, :suspended], prefix: true
  predicate :role, [:editor, :viewer], strict: true

  def initialize(age: nil, account_type: nil, role: nil)
    @age = age
    @account_type = account_type
    @role = role
  end

  def age_range
    return nil unless age

    case age
    when 0...30 then "young"
    when 30...60 then "middle"
    else "old"
    end
  end
end

class PredicateableTest < Minitest::Test
  def test_default_predicate_allows
    user = User.new(age: 10)

    assert user.young?
  end


  def test_strict_predicate_matches_symbol
    user = User.new(role: :editor)

    assert user.editor?
  end

  def test_strict_predicate_rejects_string
    user = User.new(role: "editor")

    refute user.editor?
  end

  def test_unexpected_value
    user = User.new(role: :unknown)

    refute user.editor?
    refute user.viewer?
  end

  def test_prefix_predicate
    user = User.new(account_type: :admin)

    assert user.account_type_admin?
    refute user.account_type_guest?
  end

  def test_nil_returns_false
    user = User.new

    refute user.young?
    refute user.account_type_admin?
    refute user.editor?
  end

  def test_undefined_predicate_raises
    user = User.new

    assert_raises(NoMethodError) { user.foobar? }
  end

  def test_respond_to_predicates
    user = User.new

    assert user.respond_to?(:young?)
    assert user.respond_to?(:account_type_admin?)
    assert user.respond_to?(:editor?)
    refute user.respond_to?(:foobar?)
  end
end
