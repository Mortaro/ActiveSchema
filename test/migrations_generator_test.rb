require 'test_helper'

class MigrationsGeneratorTest < Rails::Generators::TestCase

  tests ActiveSchema::MigrationsGenerator
  destination File.expand_path("./tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test "It creates a migration for added attributes" do
    schema = User.schema.merge birth: {type: 'date'}, gender: {type: 'integer'}
    User.stub :schema, schema do
      run_generator
      assert_migration "db/migrate/add_column_birth_to_user.rb" do |migration|
        assert_instance_method :change, migration do |change|
          assert_match(/add_column/, change)
          assert_match(/birth/, change)
          assert_match(/date/, change)
        end
      end
      assert_migration "db/migrate/add_column_gender_to_user.rb"
    end
  end

  test "It creates a migration for removed attributes" do
    schema = User.schema.except :name
    User.stub :schema, schema do
      run_generator
      assert_migration "db/migrate/remove_column_name_from_user.rb" do |migration|
        assert_instance_method :change, migration do |change|
          assert_match(/remove_column/, change)
          assert_match(/name/, change)
          assert_match(/string/, change)
        end
      end
    end
  end

end

