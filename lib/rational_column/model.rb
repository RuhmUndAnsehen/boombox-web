# frozen_string_literal: true

module RationalColumn
  ##
  # Mixin for ActiveRecord::Base that overrides the definition of attribute
  # methods.
  #
  # If a column is detected to be of rational type (which by default means that
  # two other columns which have the appended suffixes +_denominator+ and
  # +_numerator+, respectively, exist), then the accessor methods avoid
  # interacting with that attribute directly to preserve the precision of
  # Rational numbers. As such, the column is shielded from the user and solely
  # used to not needlessly slow down SQL queries.
  module Model
    extend ActiveSupport::Concern

    class_methods do
      ##
      # Returns the name of the denominator column for the given rational
      # column.
      #
      # Override this if your Model doesn't adhere to the naming conventions
      # (i.e. it was created before this functionality was added).
      def denominator_column_name(name) = "#{name}_denominator"

      # :nodoc:
      def define_method_attribute(name, **)
        return super unless rational_column?(name)

        define_method(name) do
          numerator =   __send__(self.class.__rational_nreader__(name))
          denominator = __send__(self.class.__rational_dreader__(name))

          Rational(numerator, denominator) if numerator && denominator
        end
      end

      # :nodoc:
      def define_method_attribute=(name, **)
        # rubocop:disable Lint/ReturnInVoidContext
        return super unless rational_column?(name)
        # rubocop:enable  Lint/ReturnInVoidContext

        # Properly initialize the shorthand attribute. We do this before
        # validation, because this also allows us to validate Rational numbers
        # using the +numericality+ validator without any extra tricks.
        before_validation { self[name] = __send__(name) }

        define_method("#{name}=") do |value|
          value = Rational(value) if value.present?
          __send__(self.class.__rational_nwriter__(name), value.try(:numerator))
          __send__(self.class.__rational_dwriter__(name),
                   value.try(:denominator))

          value
        end
      end

      ##
      # Returns the name of the numerator column for the given rational column.
      #
      # Override this if your Model doesn't adhere to the naming conventions
      # (i.e. it was created before this functionality was added).
      def numerator_column_name(name) = "#{name}_numerator"

      ##
      # Returns +true+ if the given +name+ fulfills the requirements to be a
      # reader attribute for Rational numers.
      #
      # I.e. returns +true+ if both the denominator and numerator columns are
      # present.
      def rational_column?(name)
        column_names.include?(__rational_dreader__(name)) &&
          column_names.include?(__rational_nreader__(name))
      end

      def __rational_dreader__(name) = denominator_column_name(name)
      def __rational_nreader__(name) = numerator_column_name(name)
      def __rational_dwriter__(name) = "#{__rational_dreader__(name)}="
      def __rational_nwriter__(name) = "#{__rational_nreader__(name)}="
    end

    private

    def sanitize_for_mass_assignment(attributes)
      attributes.reject! do |attr, _|
        rational_assignment_conflict?(attr, attributes)
      end
      super(attributes)
    end

    def rational_assignment_conflict?(name, attributes)
      self.class.rational_column?(name) &&
        (attributes.key?(self.class.__rational_dreader__(name)) ||
         attributes.key?(self.class.__rational_nreader__(name)))
    end
  end
end
