# frozen_string_literal: true

module RationalColumn
  ##
  # Defines a #rational pseudo column type to be used in migrations.
  module Schema
    ##
    # Rational pseudo column type.
    #
    # When invoked, three columns are defined:
    # * #float column with the +name+ as given (used for faster DB queries)
    # * #integer column with the +name+ and +_denominator+ as the suffix
    # * #integer column with the +name+ and +_numerator+ as the suffix
    #
    # In the model, the user typically only interacts with the attribute for the
    # +name+ column, which works with Rational instead of Float, shielding the
    # actual column from the user.
    def rational(name, index: nil, **options)
      column(name, :float, index:, **options)
      column(:"#{name}_denominator", :integer, **options)
      column(:"#{name}_numerator", :integer, **options)
    end
  end
end
