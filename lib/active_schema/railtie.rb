module ActiveSchema

  def self.default_schema
    {id: {type: 'integer'}, created_at: {type: 'datetime'}, updated_at: {type: 'datetime'}}
  end

  def self.load!
    Dir["#{Rails.root}/app/models/*.rb"].each do |file|
      klass_name = file.split('/').last.split('.').first
      schema_file = "#{Rails.root}/app/schemas/#{klass_name}.yml"
      klass = klass_name.classify.constantize
      schema = YAML.load(File.read(schema_file)).with_indifferent_access
      attributes = schema[klass_name] rescue {}
      attributes.merge! default_schema
      klass.send(:define_singleton_method, :schema) { attributes }
    end
  end

  class Railtie < Rails::Railtie
    config.to_prepare { ActiveSchema.load! }
  end

end
