require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "its .schema returns a hash" do
    assert_kind_of Hash, User.schema
  end

  test "its .schema contais attribute type" do
    assert_equal 'string', User.schema[:name][:type]
  end

end
