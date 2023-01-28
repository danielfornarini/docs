# frozen_string_literal: true

module JSONAPIHelpers
  def self.define_schema(name, attributes: { type: 'object' }, relationships: { type: 'object' }, extend: false)
    validate_json_api_object! attributes
    validate_json_api_object! relationships

    if extend
      current_schema = schema_from_name(name)
      defined_schemas[name] = current_schema.deep_merge({
                                                          properties: {
                                                            attributes: {
                                                              properties: attributes[:properties],
                                                              required: (current_schema[:properties][:attributes][:required] + (attributes[:required] || [])).uniq
                                                            },
                                                            relationships:
                                                          }
                                                        })
    else
      defined_schemas[name] = {
        type: 'object',
        properties: {
          id: { type: :string },
          type: { type: 'string', enum: [name.to_s.pluralize] },
          attributes:,
          relationships:
        }
      }
    end
  end

  def self.validate_json_api_object!(object)
    raise 'Invalid schema: type should be "object"' unless object[:type] == 'object'
    raise 'Invalid schema: properties should be an Hash' if object[:properties] && !object[:properties].is_a?(Hash)
    raise 'Invalid schema: required should be an Array' if object[:required] && !object[:required].is_a?(Array)
  end

  def self.defined_schemas
    @schemas ||= {}
  end

  def self.schemas
    ActiveRecord::Base.descendants.each_with_object({}) do |model, output|
      next if model.abstract_class?

      schema = schema_for(model)
      output[model.model_name.singular.to_sym] = schema if schema
    end.merge(defined_schemas)
  end

  def self.schema_from_name(model)
    schema = ActiveRecord::Base.descendants.find do |model_class|
      model_class.model_name.singular.to_s == model.to_s
    end

    schema ? schema_for(schema) : nil
  end

  def self.schema_for(model)
    serializer = ActiveModel::Serializer.serializer_for(model)
    return unless serializer

    schema = {
      type: 'object',
      properties: {
        id: { type: :string },
        type: { type: 'string', enum: [model.model_name.plural.camelize(:lower)] },
        attributes: {
          type: 'object',
          properties: {
          },
          required: []
        },
        relationships: {
          type: 'object',
          properties: {}
        }
      },
      required: %w[id type attributes]
    }

    attributes = schema[:properties][:attributes]
    relationships = schema[:properties][:relationships][:properties]

    serializer._attributes.each do |attr|
      attr_name = attr.to_s.camelize(:lower).to_sym
      attributes[:properties][attr_name] = parse_type(model, attr)
      attributes[:required] << attr_name.to_s
    end
    serializer._reflections.each do |key, _rel|
      original_rel = model.reflect_on_association(key.to_sym)
      relationships[key] = {
        type: 'object',
        properties: {
          data: {
            type: 'object',
            properties: {
              id: { type: :string },
              type: { type: 'string', enum: [original_rel.klass.model_name.plural.camelize(:lower)] }
            }
          }
        }
      }
    end

    schema
  end

  def self.parse_type(model, attr)
    case model.type_for_attribute(attr).type
    when :integer
      { type: :integer }
    when :float
      { type: :number }
    when :datetime
      { type: :string, format: :date_time }
    when :boolean
      { type: :boolean }
    when :decimal
      { type: :string, pattern: '^-?\d+.\d+$' }
    else
      { type: :string }
    end
  end

  def json_single(model)
    {
      type: 'object',
      properties: {
        data: {
          '$ref' => "#/components/schemas/#{model}"
        },
        meta: { type: :object },
        included: {
          type: 'array',
          items: { '$ref' => '#/components/schemas/generic_model' }
        }
      },
      required: ['data']
    }
  end

  def json_list(model, paginated: false)
    {
      type: 'object',
      properties: {
        data: {
          type: 'array',
          items: { '$ref' => "#/components/schemas/#{model}" }
        },
        included: {
          type: 'array',
          items: { '$ref' => '#/components/schemas/generic_model' }
        },
        meta: { type: :object },
        links: { '$ref' => '#/components/schemas/links' }
      },
      required: paginated ? %w[data links meta] : ['data']
    }
  end

  def define_json_api_params!(pagination: false)
    parameter name: :include, type: :string, in: :query, required: false
    parameter name: :fields, type: :string, in: :query, required: false
    consumes 'application/json', 'application/x-www-form-urlencoded'
    produces 'application/json'
    let(:include) { nil }

    return unless pagination

    parameter name: :'page[number]', type: :string, in: :query, required: false
    parameter name: :'page[size]', type: :string, in: :query, required: false
  end
end

RSpec.configure do |config|
  config.extend JSONAPIHelpers, type: :request
end
