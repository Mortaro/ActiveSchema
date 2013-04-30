=begin
require 'rails/generators/active_record/model/model_generator'

module ActiveSchema
  module ModelGenerator
    def generate_schema
      puts 'generate schema file when a model is generated'
    end
  end
end

ActiveRecord::Generators::ModelGenerator.send :include, ActiveSchema::ModelGenerator
=end
