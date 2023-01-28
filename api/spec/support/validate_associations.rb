# frozen_string_literal: true

module ValidateAssociations
  module ClassMethods
    def validate_associations!(check_dependent: true)
      is_read_only = described_class.new.readonly?
      described_class.reflect_on_all_associations.each do |association|
        it "validate #{described_class.name}##{association.name}" do
          if association.is_a?(ActiveRecord::Reflection::HasManyReflection) ||
             (association.is_a?(ActiveRecord::Reflection::ThroughReflection) &&
              association.instance_variable_get(:@delegate_reflection).is_a?(ActiveRecord::Reflection::HasManyReflection)) ||
             association.is_a?(ActiveRecord::Reflection::HasAndBelongsToManyReflection)
            expect(subject.send(association.name)).to eq([])
          else
            expect { subject.send(association.name) }.not_to raise_error
          end
          unless association.options[:polymorphic]
            expect do
              described_class.joins(association.name).where('1 = 0').to_a
            end.not_to raise_error
          end
        end

        if association.is_a?(ActiveRecord::Reflection::HasManyReflection) || association.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          it "validate that #{described_class.name}##{association.name} has an inverse" do
            next if association.polymorphic?

            inverse = case association
                      when ActiveRecord::Reflection::HasManyReflection
                        association.inverse_of
                      when ActiveRecord::Reflection::BelongsToReflection
                        inverse_name = ActiveSupport::Inflector.underscore(association.active_record.name.demodulize).pluralize.to_sym
                        reflection = begin
                          association.klass._reflect_on_association(inverse_name)
                        rescue StandardError
                          false
                        end
                        if reflection && association.klass <= reflection.active_record
                          reflection
                        else
                          association.inverse_of
                        end
                      end

            skip "Missing inverse: #{described_class.name}##{association.name}" unless inverse
          end
        end

        next unless check_dependent && association.is_a?(ActiveRecord::Reflection::HasManyReflection) && !is_read_only

        it "validate that #{described_class.name}##{association.name} has dependent: :something" do
          expect(association.options[:dependent]).not_to be_nil, 'Please define a dependent option!'

          inverse = association.inverse_of
          expect(association.options[:dependent]).not_to be(:nullify) if inverse && !inverse.options[:optional]
        end
      end
    end

    def check_validations!(exclusions: [])
      it 'has correct "presence" validations' do
        model = create(:"#{described_class.to_s.underscore}")

        described_class.attribute_names.each do |attribute|
          model.restore_attributes
          next if attribute.in?(%w[id updated_at created_at] + exclusions)

          expect { model.update!(attribute.to_sym => nil) }.not_to raise_error ActiveRecord::StatementInvalid
        end

        described_class.reflect_on_all_associations.each do |association|
          next if exclusions.include?(association.name.to_sym)

          model.restore_attributes
          next unless association.is_a?(ActiveRecord::Reflection::BelongsToReflection) ||
                      association.is_a?(ActiveRecord::Reflection::HasOneReflection)

          next if association.class_name == 'ActiveStorage::Attachment'

          model.send("#{association.name}=", nil)
          expect { model.save! }.not_to raise_error ActiveRecord::StatementInvalid
        end
      end

      it 'has correct "uniqueness" validations' do
        model = create(:"#{described_class.to_s.underscore}")
        expect { model.dup.save }.not_to raise_error ActiveRecord::RecordNotUnique
      end
    end

    def validate_scopes!(except: [])
      methods = (described_class.public_methods - described_class.superclass.public_methods - except).map do |m|
        described_class.method(m)
      end
      methods.select { |m| m.source_location.first.include?('scoping/') }.each do |scope|
        it "validate scope #{described_class.name}##{scope.name}" do
          scope.call
        rescue ArgumentError
          skip "can't infer default parameters for #{scope.name}"
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.extend ValidateAssociations::ClassMethods, type: :model
end
