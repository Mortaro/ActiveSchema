require 'rails/generators'

module ActiveSchema
  class MigrationsGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "Observe schema and generates the proper migrations"

    class_option :execute, type: 'boolean', default: false, aliases: '-e', desc: 'Automatically run rake db:migrate after they are generated'

    def create_columns
      ActiveRecord::Base.subclasses.each do |model|
        model_name = model.to_s.underscore
        created_columns = (model.schema.keys - model.column_names).map &:to_sym
        created_columns.each do |column_name|
          migration_name = "add_column_#{column_name}_to_#{model_name}"
          migration_command = "#{column_name}:#{model.schema[column_name][:type]}"
          invoke 'active_record:migration', [migration_name, migration_command]
        end
      end
    end

    def remove_columns
      ActiveRecord::Base.subclasses.each do |model|
        model_name = model.to_s.underscore
        removed_columns = (model.column_names - model.schema.keys).map &:to_sym
        removed_columns.each do |column_name|
          migration_name = "remove_column_#{column_name}_from_#{model_name}"
          migration_command = "#{column_name}:#{model.columns_hash[column_name.to_s].type}"
          invoke 'active_record:migration', [migration_name, migration_command]
        end
      end
    end

    def migrate
      rake 'db:migrate' if options[:execute]
    end

  end
end

